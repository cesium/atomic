class Role < ActiveRecord::Base
  has_many    :terms
  belongs_to  :department

  validates :title, presence: true
end
