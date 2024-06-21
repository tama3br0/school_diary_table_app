# config/initializers/omniauth.rb
OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.request_validation_phase = nil
