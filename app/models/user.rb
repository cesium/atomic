class User < ActiveRecord::Base
  scope :members, -> { where(type: "Member") }
  scope :buddies, -> { where(type: "Buddy") }

  has_many :payments

  validates :account_number, presence: true, length: { maximum: 10 }
  validates :student_id, presence: true, length: { maximum: 10 }
  validates :name, presence: true, length: { maximum: 75 }
  validates :street, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :phone_number, presence: true, length: { maximum: 15 }
  validates :birthdate, presence: true
end
