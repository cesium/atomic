class User < ActiveRecord::Base
  scope :members, -> { where(type: "Member") }
  scope :buddies, -> { where(type: "Buddy") }

  has_many :payments
  has_many :terms
  has_many :roles, through: :term
  has_many :registrations

  validates :account_number,
    length: { maximum: 10 },
    format: { with: /[0-9]*/ }
  validates :student_id,
    length: { maximum: 10 }
  validates :name,
    presence: true,
    length: { maximum: 75 }
  validates :city,
    length: { maximum: 30 }
  validates :phone_number,
    length: { maximum: 15 },
    format: { with: /[0-9]*/ }

  def self.from_omniauth(auth)
    user = find_or_create_from_omniauth(auth)
    user.save! unless user.new_record?
    user
  end

  private

  def self.find_or_create_from_omniauth(auth)
    find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |user|
      user.name = auth['info']['name']
      user.image = auth['info']['image']
      user.email = auth_email(auth)
    end
  end

  def self.auth_email(auth)
      auth['info']['email'] || "#{auth['uid']}@#{auth['provider']}.com"
  end
end
