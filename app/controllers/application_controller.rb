class ApplicationController < ActionController::Base
    before_action :authenticate_user!, unless: :devise_controller?
    before_action :check_user_authentication
    before_action :set_user_info, if: :user_signed_in?

    private

    def check_user_authentication
      Rails.logger.info "check_user_authentication: user_signed_in?=#{user_signed_in?}"
      if user_signed_in?
        if current_user.grade_class_id.nil? && !skip_authentication_check_for_current_path?
          Rails.logger.info "Redirecting to additional_info_path"
          redirect_to additional_info_path
        end
      else
        if request.path == authenticated_root_path
          Rails.logger.info "Redirecting to unauthenticated_root_path"
          redirect_to unauthenticated_root_path unless request.path == unauthenticated_root_path
        end
      end
    end

    def skip_authentication_check_for_current_path?
      result = request.path == additional_info_path ||
               request.path == destroy_user_session_path ||
               request.path == save_additional_info_path
      Rails.logger.info "skip_authentication_check_for_current_path?: #{result}"
      result
    end

    def after_sign_out_path_for(_resource_or_scope)
      Rails.logger.info "after_sign_out_path_for: Redirecting to unauthenticated_root_path"
      unauthenticated_root_path
    end

    def after_sign_in_path_for(resource)
      Rails.logger.info "after_sign_in_path_for: additional_info_provided=#{resource.additional_info_provided}"
      if resource.additional_info_provided
        flash[:notice] = 'ログイン できました！'
        authenticated_root_path
      else
        additional_info_path
      end
    end

    def set_user_info
      @user = current_user
      if @user.grade_class.present?
        @school_code = @user.grade_class.school_code
        @grade = @user.grade_class.grade
        @class_num = @user.grade_class.class_num
        @student_num = @user.student_num
        @role = @user.role
        @name = @user.name
      end
    end
end
