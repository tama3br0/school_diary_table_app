# frozen_string_literal: true

Devise.setup do |config|

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 12

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  if Rails.env.development?
    config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
      scope: 'userinfo.email, userinfo.profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      access_type: 'offline',
      provider_ignores_state: true,  # 開発環境ではCSRFトークンのチェックを無効化
      redirect_uri: 'http://localhost:3000/users/auth/google_oauth2/callback'
    }
  else
    config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
      scope: 'userinfo.email, userinfo.profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      access_type: 'offline',
      redirect_uri: 'https://school-diary.xyz/users/auth/google_oauth2/callback'
    }
  end

  OmniAuth.config.allowed_request_methods = %i[get post]
  OmniAuth.config.silence_get_warning = true

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
