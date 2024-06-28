class TeachersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_teacher

    def select_class
        @grade_classes = GradeClass.where(school_code: current_user.grade_class.school_code).order(:grade, :class_num)
    end

    def student_list
        @grade_class = GradeClass.find(params[:id])

        # @grade_classオブジェクトのusers関連付けを使って、そのクラスに属するユーザーのリストを取得し、取得したユーザーの中からroleが'student'のユーザーのみをフィルタリング
        @students = @grade_class.users.where(role: 'student')
    end

    def remove_student
        student = User.find(params[:id])
        if student.destroy
            redirect_to student_list_path(student.grade_class), notice: '生徒アカウントを削除しました。'
        else
            redirect_to student_list_path(student.grade_class), alert: '生徒アカウントの削除に失敗しました。'
        end
    end

    def select_class_graphs
        @grade_classes = GradeClass.where(school_code: current_user.grade_class.school_code).order(:grade, :class_num)
    end

    def emotion_distribution
        @grade_class = GradeClass.find(params[:id])

        # 指定されたクラスに属する学生（roleが0）のリストを取得し、student_numの順に並び替えて@studentsインスタンス変数に代入
        @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)

        # パラメータに日付が指定されている場合はそれを解析してdateに代入し、指定されていない場合は現在の日付を使用する
        date = params[:date].present? ? Date.parse(params[:date]) : Date.current

        # typeにパラメータで渡されたタイプを代入し、指定されていない場合は'daily'をデフォルト
        type = params[:type] || 'daily'

        # Diaryモデルのemotion_distributionメソッドを呼び出して、指定されたクラスの感情分布を取得
        @daily_distribution = {
            question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :daily, date),
            question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :daily, date),
            question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :daily, date),
            question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :daily, date)
        }

        @monthly_distribution = {
            question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :monthly, date),
            question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :monthly, date),
            question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :monthly, date),
            question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :monthly, date)
        }

        @overall_distribution = {
            question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1),
            question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2),
            question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3),
            question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4)
        }

        @previous_date = @grade_class.users.joins(:diaries).where('diaries.date < ?', date).order('diaries.date DESC').pluck(:date).first
        @next_date = @grade_class.users.joins(:diaries).where('diaries.date > ?', date).order('diaries.date ASC').pluck(:date).first

        respond_to do |format|
            format.html
            format.json { render json: { daily: @daily_distribution, monthly: @monthly_distribution, overall: @overall_distribution, previous_date: @previous_date, next_date: @next_date } }
        end
    end

    private

    def ensure_teacher
        redirect_to root_path, alert: 'アクセス権がありません。' unless current_user.teacher?
    end
end
