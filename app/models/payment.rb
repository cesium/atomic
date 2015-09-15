class Payment < ActiveRecord::Base
  belongs_to :member
  belongs_to :buddy

  validates :date, presence: true
  validates :value, presence: true, :numericality => { greater_than: 0 }
end
