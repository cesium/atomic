class Department < ActiveRecord::Base
  has_many :roles

  validates :title, presence: true, allow_nil: false, allow_blank: false
end
