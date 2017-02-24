Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    scope: 'email', image_size: 'large'
  provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET']
end
