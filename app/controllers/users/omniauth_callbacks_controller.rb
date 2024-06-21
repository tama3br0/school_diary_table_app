class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
        # 成功した場合には常にlogin_success_pathにリダイレクト
        redirect_to login_success_path
    end

    def failure
        # 失敗した場合にはlogin_failure_pathにリダイレクト
        redirect_to login_failure_path
    end
end
