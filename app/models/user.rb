class User < ApplicationRecord
  has_many :registrations
  has_one :identity

  validates :hashname,
    presence: true

  validates :email,
    presence: true

  validates :name,
    presence: true,
    length: { maximum: 75 }

  validates :phone_number,
    length: { maximum: 15 },
    format: { with: /[0-9]*/ }

  validates :cesium_id,
    length: { maximum: 10 },
    format: { with: /[0-9]*/ }

  validates :student_id,
    length: { maximum: 10 }

  def permissions
    return :guest unless persisted?
    return :user unless activity_admin?
    :activity_admin
  end
end
