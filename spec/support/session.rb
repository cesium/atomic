module SpecHelpers
  module Session
    def admin_sign_in
      allow_any_instance_of(CanCan::ControllerResource).to receive(:load_and_authorize_resource) { nil }
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers::Session, type: :controller
end
