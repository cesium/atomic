class Term < ActiveRecord::Base
  belongs_to :user
  belongs_to :board
  belongs_to :department
  belongs_to :role
end
