class ApplicationController < ActionController::Base
    before_action :authenticate_user!, unless: :devise_controller?
    before_action :check_user_authentication
    before_action :set_user_info, if: :user_signed_in?
    include UsersHelper

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
      user_info = extract_user_info(current_user)
      user_info.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      Rails.logger.info "User Info - name: #{@name}, grade: #{@grade}, class_num: #{@class_num}, student_num: #{@student_num}, role: #{@role}"
    end
end
