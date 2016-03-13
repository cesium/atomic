class Board < ActiveRecord::Base
  has_many :terms
  has_many :roles, through: :terms

  validates :year, presence: true, allow_nil: false
  validates :start, presence: true, allow_nil: false
  validates_inclusion_of :year, in: 1990..DateTime.now.year
end
