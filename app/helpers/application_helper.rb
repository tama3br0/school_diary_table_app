module ApplicationHelper

    def full_title(page_title = '')
        base_title = "がっこうにっき"
        if page_title.empty?
            base_title
        else
            "#{page_title} | #{base_title}"
        end
    end

    # 追加するヘルパーメソッド
    def date_classes(date)
        classes = []
        classes << "today" if date == Date.current
        classes << "past" if date < Date.current
        classes << "future" if date > Date.current
        classes << "current-month" if date.month == Date.current.month
        classes << "not-current-month" if date.month != Date.current.month
        classes.join(" ")
    end
end
