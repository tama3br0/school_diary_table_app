class DiariesController < ApplicationController
    include DiariesHelper

    before_action :authenticate_user!
    before_action :authorize_teacher, only: [:class_selection, :class_diary, :student_diary]

    def new
      @diary = Diary.new
      @questions = get_questions_with_emotions
    end

    def create
      diary_date = Date.current
      current_user.diaries.where(date: diary_date).destroy_all

      @questions = get_questions_with_emotions
      answers = params[:answers].values
      successful_save = true

      answers.each do |answer|
        question_num = answer[:question_num].to_i
        emotion_num = answer[:emotion_num].to_i

        question = @questions.find { |q| q[:question_num] == question_num }
        emotion = question[:emotions].find { |e| e[:emotion_num] == emotion_num }
        answer_image = emotion[:image_url]

        diary_entry = current_user.diaries.build(date: diary_date, question_num: question_num, emotion_num: emotion_num, answer_image: answer_image)

        if diary_entry.save
          current_user.stamps.create!(diary: diary_entry, stamp_image: 'https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/stamp.png')
        else
          successful_save = false
          break
        end
      end

      if successful_save
        redirect_to login_success_path, notice: 'にっきを ていしゅつしました。'
      else
        flash.now[:alert] = 'にっきのとうろくにしっぱいしました。もういちどためしてください。'
        @diary = Diary.new(diary_params)
        render :new
      end
    end

    def show
        @date = params[:date] ? Date.parse(params[:date]) : Diary.find(params[:id]).date
        @diaries = current_user.diaries.where(date: @date)
        @previous_day = current_user.diaries.where('date < ?', @date).order(date: :desc).first
        @next_day = current_user.diaries.where('date > ?', @date).order(date: :asc).first
    end

    def class_selection
      @classes = GradeClass.joins(:users).where(school_code: current_user.grade_class.school_code, users: { role: 0 }).distinct
    end

    def class_diary
        @grade_class = GradeClass.find(params[:id])
        @date = params[:date] ? Date.parse(params[:date]) : Date.current
        @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)
        @previous_date = @grade_class.users.joins(:diaries).where('diaries.date < ?', @date).order('diaries.date DESC').pluck(:date).first
        @next_date = @grade_class.users.joins(:diaries).where('diaries.date > ?', @date).order('diaries.date ASC').pluck(:date).first
    end

    def student_diary
        @student = User.find(params[:id])
        @date = params[:date] ? Date.parse(params[:date]) : Date.current
        @diaries = @student.diaries.where('date >= ? AND date <= ?', @date.beginning_of_month, @date.end_of_month)
        @previous_month = @date.prev_month
        @next_month = @date.next_month
    end

    def new_for_student
        @student = User.find(params[:student_id])
        @date = params[:date] ? Date.parse(params[:date]) : Date.current
        @diary = @student.diaries.build(date: @date)
        @questions = get_questions_with_emotions
    end

    def create_for_student
        @student = User.find(params[:student_id])
        diary_date = params[:date]
        @student.diaries.where(date: diary_date).destroy_all

        @questions = get_questions_with_emotions
        answers = params[:answers].values
        successful_save = true

        answers.each do |answer|
          question_num = answer[:question_num].to_i
          emotion_num = answer[:emotion_num].to_i

          question = @questions.find { |q| q[:question_num] == question_num }
          emotion = question[:emotions].find { |e| e[:emotion_num] == emotion_num }
          answer_image = emotion[:image_url]

          diary_entry = @student.diaries.build(date: diary_date, question_num: question_num, emotion_num: emotion_num, answer_image: answer_image)

          if diary_entry.save
            @student.stamps.create!(diary: diary_entry, stamp_image: 'https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/stamp.png')
          else
            successful_save = false
            break
          end
        end

        if successful_save
          redirect_to class_diary_path(@student.grade_class, date: diary_date), notice: '日記を代わりに提出しました。'
        else
          flash.now[:alert] = '日記の登録に失敗しました。もう一度試してください。'
          @diary = @student.diaries.build(diary_params)
          render :new_for_student
        end
    end



    private

    def diary_params
      params.require(:diary).permit(:date)
    end

    def authorize_teacher
      unless current_user.teacher?
        redirect_to authenticated_root_path, alert: 'アクセス権限がありません。'
        return
      end

      if params[:id] && action_name != 'class_selection' && action_name != 'student_diary'
        begin
          grade_class = GradeClass.find(params[:id])
          unless current_user.grade_class.school_code == grade_class.school_code
            redirect_to authenticated_root_path, alert: 'アクセス権限がありません。'
          end
        rescue ActiveRecord::RecordNotFound
          redirect_to authenticated_root_path, alert: '指定されたクラスは存在しません。'
        end
      end
    end
end
