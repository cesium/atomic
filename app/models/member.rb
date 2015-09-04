class Member < User
  has_one :payment, foreign_key: :user_id, dependent: :destroy
end
