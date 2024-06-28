class PagesController < ApplicationController
    def login_success
        @diaries = current_user.diaries
        @stamps = current_user.stamps.includes(:diary)

        @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Time.zone.today
        # Rails.logger.debug "Start date: #{@start_date}"
        @previous_link = @start_date.prev_month
        @today_link = Time.zone.today
        # Rails.logger.debug "Today's date: #{@today_link}"
        @next_link = @start_date.next_month

        @weeks = build_weeks(@start_date)
    end

    def login_failure
    end

    private

    def build_weeks(start_date)
        end_date = start_date.end_of_month.end_of_week(:sunday)
        (start_date.beginning_of_month.beginning_of_week(:sunday)..end_date).to_a.in_groups_of(7)
    end
end