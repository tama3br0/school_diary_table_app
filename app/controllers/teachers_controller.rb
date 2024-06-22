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

    private

    def ensure_teacher
      redirect_to root_path, alert: 'アクセス権がありません。' unless current_user.teacher?
    end
end
