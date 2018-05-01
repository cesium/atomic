class Identity < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth)
    identity = find_or_create_from_omniauth(auth)
    identity.save! && identity.user.save! unless identity.new_record?
    identity.user
  end

  def self.find_or_create_from_omniauth(auth)
    find_or_create_by(uid: auth["uid"], provider: auth["provider"]) do |id|
      user = id.build_user
      user.name = auth["info"]["name"] || auth["info"]["nickname"]
      user.image = auth["info"]["image"]
      user.email = auth_email(auth)
      user.hashname = user.name.hash
    end
  end

  def self.auth_email(auth)
    auth["info"]["email"] || "#{auth['uid']}@#{auth['provider']}.com"
  end

  private_class_method :find_or_create_from_omniauth, :auth_email
end
