Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "reply@example.com"
  Clearance::SessionsController.layout 'welcome'
  Clearance::PasswordsController.layout 'welcome'
  Clearance::UsersController.layout 'welcome'
end
