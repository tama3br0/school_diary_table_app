class UsersController < ApplicationController
    before_action :authenticate_user!
    include UsersHelper

    def additional_info
      @user = current_user
    end

    def save_additional_info
        @user = current_user
        @user.skip_validations = false

        grade_class = GradeClass.find_or_create_by(
          grade: params[:user][:grade].to_i,
          class_num: params[:user][:class_num].to_i,
          school_code: params[:user][:school_code].to_i
        )

        @user.grade_class = grade_class
        @user.assign_attributes(user_params.except(:grade, :class_num, :school_code))
        @user.additional_info_provided = true

        if @user.valid? && unique_combination?(grade_class, @user.student_num)
          @user.save
          respond_to do |format|
            format.html { redirect_to authenticated_root_path, notice: 'とうろく できました！' }
            format.turbo_stream { redirect_to authenticated_root_path, notice: 'とうろく できました！' }
          end
        else
          flash.now[:alert] = @user.errors.full_messages.join("\n")
          flash.now[:alert] = "すでに とうろくされているひとが います" if @user.errors[:student_num].include?("すでに、ほかのひとが とうろく されています")

          respond_to do |format|
            format.html { render :additional_info }
            format.turbo_stream {
              render turbo_stream: turbo_stream.replace("additional_info_form", partial: "users/additional_info_form", locals: { user: @user })
            }
          end
        end
    end


    private

    def user_params
      params.require(:user).permit(:role, :name, :student_num, :grade, :class_num, :school_code)
    end
end
