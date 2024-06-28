Devise.setup do |config|
    # メール送信者アドレスの設定
    config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

    # 使用するORMの設定。ここではActiveRecordを使用
    require 'devise/orm/active_record'

    # 認証キーの大文字小文字を区別しないように設定
    config.case_insensitive_keys = [:email]

    # 認証キーの前後の空白を削除するように設定
    config.strip_whitespace_keys = [:email]

    # セッションストレージをスキップする場合の設定。ここではHTTP認証をスキップ
    config.skip_session_storage = [:http_auth]

    # パスワードのストレッチ回数の設定
    config.stretches = Rails.env.test? ? 1 : 12

    # 再確認を有効にするかどうかの設定
    config.reconfirmable = true

    # サインアウト時に「remember me」を全て無効化
    config.expire_all_remember_me_on_sign_out = true

    # パスワードの長さの範囲を設定
    config.password_length = 6..128

    # メールアドレスの正規表現を設定
    config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

    # パスワードリセットの有効期限を設定
    config.reset_password_within = 6.hours

    # サインアウトの方法を設定
    config.sign_out_via = :delete

    # OmniAuthのGoogle認証の設定。開発環境と本番環境で異なる設定を使用
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

    # OmniAuthの設定
    OmniAuth.config.allowed_request_methods = %i[get post]
    OmniAuth.config.silence_get_warning = true

    # Responderの設定
    config.responder.error_status = :unprocessable_entity
    config.responder.redirect_status = :see_other
end
