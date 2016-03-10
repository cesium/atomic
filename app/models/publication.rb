class Publication < ActiveRecord::Base
  scope :posts,     -> { where(type: "Post") }
  scope :articles,  -> { where(type: "Article") }

  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  presence: true

  belongs_to :user
  has_many :comments
end
