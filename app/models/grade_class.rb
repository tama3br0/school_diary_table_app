class GradeClass < ApplicationRecord
    has_many :users, dependent: :destroy
end
