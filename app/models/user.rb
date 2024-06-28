class User < ApplicationRecord
    devise :database_authenticatable, :recoverable, :rememberable, :validatable,
           :omniauthable, omniauth_providers: [:google_oauth2]

    belongs_to :grade_class, optional: true
    has_many :diaries, dependent: :destroy
    has_many :stamps, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
    validates :role, presence: true, unless: :skip_validations
    validates :student_num, presence: true, if: -> { student? && !skip_validations }
    validates :name, presence: true, if: -> { teacher? && !skip_validations }
    validates :grade_class, presence: true, if: -> { student? && !skip_validations }

    attr_accessor :skip_validations

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
            user.email = auth.info.email
            user.password = Devise.friendly_token[0, 20] if user.new_record?
            user.name = auth.info.name
            user.skip_validations = true
            user.additional_info_provided = false if user.new_record?
            user.save!(validate: false)
        end
    end

    enum role: { student: 0, teacher: 1 }

    def teacher?
        role == 'teacher'
    end

    def student?
        role == 'student'
    end

end
