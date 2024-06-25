class Diary < ApplicationRecord
    belongs_to :user
    has_many :stamps, dependent: :destroy

    validates :user_id, presence: true
    validates :date, presence: true
    validates :question_num, presence: true
    validates :emotion_num, presence: true
    validates :answer_image, presence: true

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
      [{ question_num: self.question_num, emotion_num: self.emotion_num }]
    end

    def self.emotion_distribution(school_code, grade, class_num, question_num, period = nil)
        query = joins(user: :grade_class)
                 .where(grade_classes: { school_code: school_code, grade: grade, class_num: class_num })
                 .where(question_num: question_num)

        case period
        when :daily
          query = query.where('date = ?', Date.current)
        when :monthly
          query = query.where('date >= ? AND date <= ?', Date.current.beginning_of_month, Date.current.end_of_month)
        end

        query.group(:emotion_num).count
    end
end
