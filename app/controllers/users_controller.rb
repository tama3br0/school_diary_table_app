class UsersController < ApplicationController
    before_action :authenticate_user!
    include UsersHelper

    def additional_info
      @user = current_user
    end

    def save_additional_info
      @user = current_user
      @user.skip_validations = false

      begin
        grade_class = GradeClass.find_or_create_by(
          grade: params[:user][:grade].to_i,
          class_num: params[:user][:class_num].to_i,
          school_code: params[:user][:school_code].to_i
        )

        @user.grade_class = grade_class
        @user.assign_attributes(user_params.except(:grade, :class_num, :school_code))
        @user.additional_info_provided = true

        if @user.valid? && unique_combination?(@user, grade_class, @user.student_num)
          @user.save
          respond_to do |format|
            format.html { redirect_to authenticated_root_path, notice: 'とうろく できました！' }
          end
        else
          flash.now[:alert] = @user.errors.full_messages.join("\n")
          flash.now[:alert] = "すでに とうろくされているひとが います" if @user.errors[:student_num].include?("すでに、ほかのひとが とうろく されています")

          respond_to do |format|
            format.html { render :additional_info }
          end
        end
      rescue => e
        Rails.logger.error("Error in save_additional_info: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        flash.now[:alert] = "An unexpected error occurred. Please try again later."
        render :additional_info
      end
    end

    private

    def user_params
      params.require(:user).permit(:role, :name, :student_num, :grade, :class_num, :school_code)
    end
end
