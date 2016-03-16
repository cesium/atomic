class Board < ActiveRecord::Base
  has_many :terms

  validates :start_date, presence: true
end
