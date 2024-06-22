class Diary < ApplicationRecord
    belongs_to :user
    has_many :stamps, dependent: :destroy

    validates :user_id, presence: true
    validates :date, presence: true
    validates :question_num, presence: true
    validates :emotion_num, presence: true

    def start_time
      date
    end

    def previous_day
      user.diaries.where('date < ?', date).order(date: :desc).first
    end

    def next_day
      user.diaries.where('date > ?', date).order(date: :asc).first
    end

    def answers
        [{ question_num: question_num, emotion_num: emotion_num }]
    end
end
