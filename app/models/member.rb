class Member < ApplicationRecord
  has_one :user

  validates :account_number,
    length: { maximum: 10 },
    format: { with: /[0-9]*/ }

  validates :student_id,
    length: { maximum: 10 }
end
