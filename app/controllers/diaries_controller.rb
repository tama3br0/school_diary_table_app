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

        if all_questions_answered?(@questions, answers)
          successful_save = true
          ActiveRecord::Base.transaction do
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
                raise ActiveRecord::Rollback
              end
            end
          end

          if successful_save
            redirect_to login_success_path, notice: 'にっきを ていしゅつしました。'
          else
            flash.now[:alert] = 'にっきのとうろくにしっぱいしました。もういちどためしてください。'
            @diary = Diary.new(diary_params)
            render :new
          end
        else
          flash.now[:alert] = 'ぜんぶの しつもんに こたえてください。'
          @diary = Diary.new(diary_params)
          render :new
        end
    end

    def show
        # params[:date]が存在する場合、それをDate.parseでパースして@dateに設定 : params[:date]が存在しない場合、params[:id]で指定されたDiaryオブジェクトをデータベースから検索し、その日付を@dateに設定
        @date = params[:date] ? Date.parse(params[:date]) : Diary.find(params[:id]).date

        # current_userの関連するdiariesから、@dateの日付に一致する日記エントリを取得し、@diariesに格納
        @diaries = current_user.diaries.where(date: @date)

        # current_userの関連するdiariesから、@dateより前の日付の日記エントリを取得
        # 取得したエントリを日付の降順（新しい順）に並べ替え、その最初のエントリ（最も新しいエントリ）を@previous_dayに格納
        @previous_day = current_user.diaries.where('date < ?', @date).order(date: :desc).first

        # current_userの関連するdiariesから、@dateより後の日付の日記エントリを取得
        # 取得したエントリを日付の昇順（古い順）に並べ替え、その最初のエントリ（最も古いエントリ）を@next_dayに格納
        @next_day = current_user.diaries.where('date > ?', @date).order(date: :asc).first
    end

    def class_selection
        # GradeClassモデルを使用して、現在ログインしているユーザーの所属する学校のクラスリストを取得
        # current_user.grade_class.school_codeは、ログインユーザーが所属するクラスのschool_codeを取得
        # where(school_code: current_user.grade_class.school_code)は、このschool_codeを持つすべてのクラスをデータベースから取得
        # order(:grade, :class_num)は、取得したクラスを学年（grade）とクラス番号（class_num）で昇順に並べ替え
        @classes = GradeClass.where(school_code: current_user.grade_class.school_code).order(:grade, :class_num)
    end

    def class_diary
        # URLパラメータidからクラスのIDを取得し、そのIDに対応するGradeClassオブジェクトをデータベースから取得し
        @grade_class = GradeClass.find(params[:id])

        # URLパラメータdateが存在する場合、その日付をパースして@dateに格納 : dateが存在しない場合は、現在の日付（Date.current）を@dateに格納
        @date = params[:date] ? Date.parse(params[:date]) : Date.current

        # 特定のクラス（@grade_class）に所属する学生（role: 0）をUserモデルから取得し、取得した学生リストをstudent_numで昇順に並べ替え
        @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)

        # @grade_classに所属するユーザーの中で、@dateより前の日付の日記エントリを持つユーザーを検索し、その日記エントリの日付を降順（新しい順）に並べ替え、最初の日付（最も新しい日付）を取得
        @previous_date = @grade_class.users.joins(:diaries).where('diaries.date < ?', @date).order('diaries.date DESC').pluck(:date).first

        # @grade_classに所属するユーザーの中で、@dateより後の日付の日記エントリを持つユーザーを検索し、その日記エントリの日付を昇順（古い順）に並べ替え、最初の日付（最も古い日付）を取得
        @next_date = @grade_class.users.joins(:diaries).where('diaries.date > ?', @date).order('diaries.date ASC').pluck(:date).first
    end

    def student_diary
        @student = User.find(params[:id])
        @date = params[:date] ? Date.parse(params[:date]) : Date.current

        # 特定の学生（@student）の@dateの月に該当する日記エントリを取得
        # date >= ?で月の初めの日付から、date <= ?で月の終わりの日付までの範囲で日記エントリを検索し、取得した日記エントリを@diariesに格納
        @diaries = @student.diaries.where('date >= ? AND date <= ?', @date.beginning_of_month, @date.end_of_month).order('diaries.date ASC')

        @previous_month = @date.prev_month
        @next_month = @date.next_month
    end

    def new_for_student
        # URLパラメータstudent_idから学生のIDを取得し、そのIDに対応するUserオブジェクトをデータベースから取得
        @student = User.find(params[:student_id])

        # URLパラメータdateが存在する場合、その日付をパースして@dateに格納 : dateが存在しない場合は、現在の日付（Date.current）を@dateに格納
        @date = params[:date] ? Date.parse(params[:date]) : Date.current

        # @studentの関連付けられたdiariesから、新しい日記エントリを作成
        # 新しい日記エントリには、日付（@date）が設定される
        @diary = @student.diaries.build(date: @date)

        @questions = get_questions_with_emotions
    end

    def create_for_student
        # URLパラメータstudent_idから学生のIDを取得し、そのIDに対応するUserオブジェクトをデータベースから取得
        @student = User.find(params[:student_id])

        # URLパラメータdateから日付を取得し、それをdiary_dateに格納
        diary_date = params[:date]
        # 取得した日付に一致する既存の日記エントリを削除
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

    def all_questions_answered?(questions, answers)
        questions.all? do |question|
          answers.any? { |answer| answer[:question_num].to_i == question[:question_num].to_i && answer[:emotion_num].present? }
        end
    end
end
