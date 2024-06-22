# app/helpers/calendar_helper.rb
module CalendarHelper
    def today_in_timezone
      Time.zone.today
    end
end
