class Comment < ActiveRecord::Base
  belongs_to :publication
  belongs_to :user

  validates :body, presence: true, length: { maximum: 600 }
end
