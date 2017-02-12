Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    scope: 'email', image_size: 'large'
end
