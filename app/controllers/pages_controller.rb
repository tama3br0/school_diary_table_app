# app/controllers/pages_controller.rb
class PagesController < ApplicationController
    def login_success
      @diaries = current_user.diaries
      @stamps = current_user.stamps.includes(:diary)
      set_user_info
    end

    def login_failure
    end

    private

    def set_user_info
      @role = current_user.role
      @grade_class = current_user.grade_class
    end
end
