# app/controllers/teachers_controller.rb
class TeachersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_teacher

    def select_class
      @grade_classes = GradeClass.where(school_code: current_user.grade_class.school_code).order(:grade, :class_num)
    end

    def student_list
      @grade_class = GradeClass.find(params[:id])
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

    def select_type_graphs
      @grade_class = GradeClass.find(params[:id])
    end

    def select_date_graphs
      @grade_class = GradeClass.find(params[:id])
      @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.current.beginning_of_week
      @end_date = @start_date.end_of_week
    end

    def select_month_graphs
      @grade_class = GradeClass.find(params[:id])
      @start_month = params[:start_month] ? Date.parse(params[:start_month]) : Date.current.beginning_of_month
      @end_month = @start_month.end_of_month
    end

    def emotion_daily_graphs
      @grade_class = GradeClass.find(params[:id])
      @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.current

      @daily_graphs = {
        question1: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :daily, @date),
        question2: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :daily, @date),
        question3: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :daily, @date),
        question4: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :daily, @date)
      }
    end

    def emotion_monthly_graphs
      @grade_class = GradeClass.find(params[:id])
      @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.current

      @monthly_graphs = {
        question1: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :monthly, @date),
        question2: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :monthly, @date),
        question3: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :monthly, @date),
        question4: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :monthly, @date)
      }
    end

    def emotion_overall_graphs
      @grade_class = GradeClass.find(params[:id])
      @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)

      @overall_graphs = {
        question1: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1),
        question2: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2),
        question3: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3),
        question4: Diary.emotion_graphs(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4)
      }
    end

    private

    def ensure_teacher
      redirect_to root_path, alert: 'アクセス権がありません。' unless current_user.teacher?
    end
end
