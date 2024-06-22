# config/initializers/omniauth.rb
if Rails.env.development?
    OmniAuth.config.allowed_request_methods = %i[get post]
    OmniAuth.config.silence_get_warning = true
    OmniAuth.config.request_validation_phase = nil
else
    OmniAuth.config.allowed_request_methods = %i[post]
    OmniAuth.config.silence_get_warning = false
    OmniAuth.config.request_validation_phase = OmniAuth::AuthenticityTokenProtection.new
end
