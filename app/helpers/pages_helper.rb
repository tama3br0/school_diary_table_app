module PagesHelper
    def user_info(user)
      info = {}
      info[:role] = user.role
      info[:name] = user.name

      if user.grade_class.present?
        info[:school_code] = user.grade_class.school_code
        info[:grade] = user.grade_class.grade
        info[:class_num] = user.grade_class.class_num
      else
        info[:school_code] = nil
        info[:grade] = nil
        info[:class_num] = nil
      end

      info[:student_num] = user.student_num
      info
    end

    def display_user_greeting(user_info)
      if user_info[:role] == 'teacher'
        "ようこそ！ #{user_info[:name]}せんせい"
      else
        "ようこそ！ #{user_info[:grade]}ねん#{user_info[:class_num]}くみの#{user_info[:student_num]}ばんさん"
      end
    end
end
