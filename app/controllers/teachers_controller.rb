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

    def emotion_distribution
        @grade_class = GradeClass.find(params[:id])
        @students = User.where(grade_class: @grade_class, role: 0).order(:student_num)

        @daily_distribution = {
          question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :daily),
          question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :daily),
          question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :daily),
          question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :daily)
        }

        @monthly_distribution = {
          question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1, :monthly),
          question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2, :monthly),
          question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3, :monthly),
          question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4, :monthly)
        }

        @overall_distribution = {
          question1: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 1),
          question2: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 2),
          question3: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 3),
          question4: Diary.emotion_distribution(@grade_class.school_code, @grade_class.grade, @grade_class.class_num, 4)
        }
    end

    # def student_diary_graph
    #     @student = User.find(params[:id])

    #     @daily_diaries = @student.diaries.where(created_at: 1.week.ago..Time.now).group_by { |d| d.created_at.to_date }
    #     @monthly_diaries = @student.diaries.where(created_at: 1.month.ago..Time.now).group_by { |d| d.created_at.beginning_of_month }
    #     @overall_diaries = @student.diaries.group_by { |d| d.created_at.beginning_of_month }

    #     Rails.logger.debug("Student ID: #{@student.id}")
    #     Rails.logger.debug("Daily Diaries: #{@daily_diaries.inspect}")
    #     Rails.logger.debug("Monthly Diaries: #{@monthly_diaries.inspect}")
    # end




    private

    def ensure_teacher
      redirect_to root_path, alert: 'アクセス権がありません。' unless current_user.teacher?
    end
end
