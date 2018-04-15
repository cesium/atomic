class Payment < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :buddy, optional: true

  validates :date, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
end
