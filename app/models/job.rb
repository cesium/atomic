class Job < ApplicationRecord
  validates :position, presence: true
  validates :company, presence: true

  validates :link, format: {
    with: %r{(http|https):\/\/*/},
    message: " is invalid, make sure your Link starts with http:// or https://"
  }

  has_attached_file :poster, default_url: "poster_default.png"
  validates_attachment_content_type :poster, content_type: %r{\Aimage\/.*\Z}
end
