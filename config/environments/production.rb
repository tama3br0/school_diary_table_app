require "active_support/core_ext/integer/time"

Rails.application.configure do
  # リクエスト間でコードがリロードされないように設定
  config.enable_reloading = false

  # ブート時にコードをイーガーロード
  config.eager_load = true

  # 完全なエラーレポートを無効にし、キャッシングを有効に
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # マスターキーがENV["RAILS_MASTER_KEY"], config/master.key, または環境キーとして提供されていることを確認
  # config.require_master_key = true

  # プリコンパイルされたアセットが見つからない場合にアセットパイプラインにフォールバックしない
  config.assets.compile = false

  # 追記: Active StorageでAWS S3を使用するための設定
  config.active_storage.service = :amazon

  # 追記: SSLを強制
  config.force_ssl = true

  # 追記: STDOUTにログを出力
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # すべてのログ行の先頭に以下のタグを付加
  config.log_tags = [ :request_id ]

  # "info" はシステム操作に関する一般的かつ有用な情報を含みますが、個人を特定できる情報 (PII) の不注意な露出を避けるためにあまり多くの情報をログに記録しません。
  # すべてをログに記録したい場合は、レベルを "debug" に設定します。
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # 本番環境で異なるキャッシュストアを使用
  # config.cache_store = :mem_cache_store

  # Active Jobのために本格的なキューイングバックエンドを使用 (環境ごとに異なるキューを使用)
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "school_diary_table_app_production"

  config.action_mailer.perform_caching = false

  # 不正なメールアドレスを無視し、メール配信エラーを発生させない
  # 配信エラーを発生させるために true に設定し、メールサーバーを即時配信に設定
  # config.action_mailer.raise_delivery_errors = false

  # I18nのロケールフォールバックを有効に (翻訳が見つからない場合にI18n.default_localeにフォールバック)
  config.i18n.fallbacks = true

  # 廃止予定の機能に関するログを記録しない
  config.active_support.report_deprecations = false

  # マイグレーション後にスキーマをダンプしない
  config.active_record.dump_schema_after_migration = false

  # 追記: アプリケーションのデフォルトURLオプションを設定
  Rails.application.routes.default_url_options = { host: 'school-diary.xyz', protocol: 'https' }

  # 追記: 許可されたホストを設定
  config.hosts << "school-diary.xyz"
  config.hosts << "www.school-diary.xyz"
end
