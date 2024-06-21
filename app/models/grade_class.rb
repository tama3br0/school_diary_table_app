class GradeClass < ApplicationRecord
    has_many :users, dependent: :destroy

    validates :grade, presence: true
    validates :class_num, presence: true
    validates :school_code, presence: true
end
