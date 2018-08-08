class User < ApplicationRecord
  has_many :registrations
  belongs_to :member, optional: true

  validates :name,
    presence: true,
    length: { maximum: 75 }

  validates :phone_number,
    length: { maximum: 15 },
    format: { with: /[0-9]*/ }

  def self.from_omniauth(auth)
    user = find_or_create_from_omniauth(auth)
    user.save! unless user.new_record?
    user
  end

  def admin?
    member&.admin
  end

  def permissions
    return :guest unless persisted?
    return :user unless admin?
    :admin
  end

  def self.find_or_create_from_omniauth(auth)
    find_or_create_by(uid: auth["uid"], provider: auth["provider"]) do |user|
      user.name = auth["info"]["name"] || auth["info"]["nickname"]
      user.image = auth["info"]["image"]
      user.email = auth_email(auth)
    end
  end

  def self.auth_email(auth)
    auth["info"]["email"] || "#{auth['uid']}@#{auth['provider']}.com"
  end

  private_class_method :find_or_create_from_omniauth, :auth_email
end
