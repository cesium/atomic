class Job < ApplicationRecord
  validates :position, presence: true
  validates :company, presence: true
  validates :link, presence: true

  has_attached_file :poster, default_url: "poster_default.png"
  validates_attachment_content_type :poster, content_type: %r{\Aimage\/.*\Z}
end
