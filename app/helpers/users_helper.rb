module UsersHelper
    def unique_combination?(user, grade_class, student_num)
      if user.student? && User.exists?(grade_class: grade_class, student_num: student_num)
        user.errors.add(:student_num, "すでに、ほかのひとが とうろく されています")
        return false
      end
      true
    end

    def teacher?(user)
      user.role == 'teacher'
    end

    def extract_user_info(user)
      if user.grade_class.present?
        {
          school_code: user.grade_class.school_code,
          grade: user.grade_class.grade,
          class_num: user.grade_class.class_num,
          student_num: user.student_num,
          role: user.role,
          name: user.name
        }
      else
        {}
      end
    end
end
