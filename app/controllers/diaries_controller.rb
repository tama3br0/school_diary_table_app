class DiariesController < ApplicationController
    include DiariesHelper

    before_action :authenticate_user!
    before_action :authorize_teacher, only: [:class_selection, :class_diary]

    def new
      @diary = Diary.new
      @questions = get_questions_with_emotions
    end

    def create
      date = diary_params[:date]
      current_user.diaries.where(date: date).destroy_all

      @questions = get_questions_with_emotions
      answers = params[:answers].values
      successful_save = true

      answers.each do |answer|
        question_num = answer[:question_num].to_i
        emotion_num = answer[:emotion_num].to_i

        question = @questions.find { |q| q[:question_num] == question_num }
        emotion = question[:emotions].find { |e| e[:emotion_num] == emotion_num }
        answer_image = emotion[:image_url]

        diary_entry = current_user.diaries.build(date: date, question_num: question_num, emotion_num: emotion_num, answer_image: answer_image)

        if diary_entry.save
          current_user.stamps.create!(diary: diary_entry, stamp_image: 'https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/stamp.png')
        else
          successful_save = false
          break
        end
      end

      if successful_save
        redirect_to login_success_path, notice: 'にっきをとうろくしました。'
      else
        flash.now[:alert] = 'にっきのとうろくにしっぱいしました。もういちどためしてください。'
        @diary = Diary.new(diary_params)
        render :new
      end
    end

    def show
      @date = params[:date] || Diary.find(params[:id]).date
      @diaries = current_user.diaries.where(date: @date)
      @previous_day = current_user.diaries.where('date < ?', @date).order(date: :desc).first
      @next_day = current_user.diaries.where('date > ?', @date).order(date: :asc).first
    end

    def class_selection
      if current_user.teacher?
        @classes = GradeClass.joins(:users).where(school_code: current_user.grade_class.school_code, users: { role: 0 }).distinct
      else
        redirect_to authenticated_root_path, alert: 'アクセス権限がありません。'
      end
    end

    def class_diary
      if valid_teacher?
        @grade_class = GradeClass.find(params[:id])
        @date = params[:date] || Date.today
        @students = User.where(grade_class: @grade_class, role: 0)
        @previous_date = @grade_class.users.joins(:diaries).where('diaries.date < ?', @date).order('diaries.date DESC').pluck(:date).first
        @next_date = @grade_class.users.joins(:diaries).where('diaries.date > ?', @date).order('diaries.date ASC').pluck(:date).first
      else
        redirect_to authenticated_root_path, alert: 'アクセス権限がありません。'
      end
    end

    def student_diary
        @student = User.find(params[:id])
        @date = params[:date] || Date.today
        @diaries = @student.diaries.where('date >= ? AND date <= ?', @date.beginning_of_month, @date.end_of_month)
        @previous_month = @date.prev_month
        @next_month = @date.next_month
    end

    private

    def diary_params
      params.require(:diary).permit(:date)
    end

    def authorize_teacher
      return if action_name == 'class_selection'
      unless current_user.teacher? && current_user.grade_class.school_code == GradeClass.find(params[:id]).school_code
        redirect_to authenticated_root_path, alert: 'アクセス権限がありません。'
      end
    end

    def valid_teacher?
      current_user.teacher? && current_user.grade_class.school_code == GradeClass.find(params[:id]).school_code
    end
end
