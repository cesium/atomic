class Department < ActiveRecord::Base
  has_many :terms

  validates :title, presence: true
end
