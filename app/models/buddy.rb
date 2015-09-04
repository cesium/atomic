class Buddy < User
  has_many :payments, foreign_key: :user_id
end
