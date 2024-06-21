class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable,
            :omniauthable, omniauth_providers: [:google_oauth2] # Googleアカウント用に追記


    belongs_to :grade_class, optional: true
    has_many :diaries, dependent: :destroy
    has_many :stamps, dependent: :destroy

    # バリデーション
    validates :email, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
    validates :role, presence: true

    validates :student_num, presence: true, if: :student?
    validates :name, presence: true, if: :teacher?

    # 役割ごとのメソッド
    def student?
        role == 0
    end

    def teacher?
        role == 1
    end

    def parent?
        role == 2
    end

      # 親が子供を持っているかどうかを確認するメソッド
    def children
        User.where(grade_class: grade_class, student_num: student_num, role: 0)
    end

      # OmniAuthからの情報を元にユーザーを作成または検索するメソッド
    def self.from_omniauth(access_token)
        data = access_token.info
        user = User.where(email: data['email']).first

        unless user
        user = User.create(
            name: data['name'],
            email: data['email'],
            uid: access_token.uid,
            provider: access_token.provider,
            password: Devise.friendly_token[0, 20]
        )
        end
        user
    end
end
