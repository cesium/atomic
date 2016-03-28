class User < ActiveRecord::Base
include Clearance::User

  scope :members, -> { where(type: "Member") }
  scope :buddies, -> { where(type: "Buddy") }

  has_many :payments
  has_many :terms
  has_many :roles, through: :term
  has_many :registrations

  validates :account_number, presence: true, length: { maximum: 10 },
    numericality: { only_integer: true }
  validates :student_id, presence: true, length: { maximum: 10 }
  validates :name, presence: true, length: { maximum: 75 }
  validates :city, length: { maximum: 30 }
  validates :phone_number, length: { maximum: 15 },
    numericality: { only_integer: true }
end
