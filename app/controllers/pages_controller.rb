# app/controllers/pages_controller.rb
class PagesController < ApplicationController
    def login_success
      @diaries = current_user.diaries
      @stamps = current_user.stamps.includes(:diary)
    end

    def login_failure
    end
end
