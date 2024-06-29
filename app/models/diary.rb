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

    # emotionの分布を集計するグラフ用のメソッド
    def self.emotion_graphs(school_code, grade, class_num, question_num, period = nil, date = Date.current)
        # diaries テーブルを users テーブルを経由しつつgrade_classes テーブルと結合
                # 指定された school_code、grade、class_num に一致する grade_classes を持つ diaries レコードをフィルタリング
                # 指定された question_num に一致する diaries レコードをさらにフィルタリング
        query = joins(user: :grade_class)
                .where(grade_classes: { school_code: school_code, grade: grade, class_num: class_num })
                .where(question_num: question_num)

        case period
        when :daily # <= teachers_controllerで定義
            query = query.where('date = ?', date)
        when :monthly # <= teachers_controllerで定義
            query = query.where('date >= ? AND date <= ?', date.beginning_of_month, date.end_of_month)
        end
        # フィルタリングされたレコードを emotion_num ごとにグループ化し、各グループのレコード数をカウント
        query.group(:emotion_num).count

        # {
            # 1 => 5,   emotion_num が 1 の日記エントリーが 5 件
            # 2 => 10,  emotion_num が 2 の日記エントリーが 10 件
            # 3 => 3    emotion_num が 3 の日記エントリーが 3 件
            # }
    end
end
