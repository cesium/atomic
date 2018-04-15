class Member < ApplicationRecord
  has_one :responsible_member, class_name: "Member"
  has_one :user
  has_many :terms
  has_many :roles, through: :term

  validates :account_number,
    length: { maximum: 10 },
    format: { with: /[0-9]*/ }

  validates :student_id,
    length: { maximum: 10 }
end
