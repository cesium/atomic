class Department < ApplicationRecord
  has_many :terms

  validates :title, presence: true
end
