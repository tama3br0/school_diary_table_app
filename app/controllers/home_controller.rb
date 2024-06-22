class HomeController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index] # <= 認証する前でもindexページが表示できるように

    def index
    end
end
