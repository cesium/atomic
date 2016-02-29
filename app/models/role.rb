class Role < ActiveRecord::Base
  has_many    :terms
  belongs_to  :department

  validates :title, presence: true, allow_nil: false
  validates :department, presence: true, allow_nil: false
end
