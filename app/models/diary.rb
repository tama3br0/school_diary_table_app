class Diary < ApplicationRecord
    belongs_to :user
    has_many :stamps, dependent: :destroy

    validates :user_id, presence: true
    validates :date, presence: true
    validates :question_num, presence: true
    validates :emotion_num, presence: true

end
