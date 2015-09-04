class User < ActiveRecord::Base
  scope :members, -> { where(type: :member) }
  scope :buddies, -> { where(type: :buddy) }

  has_many :payments
end
