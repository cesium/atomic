class Article < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 75 }
  validates :text, presence: true

  has_attached_file :poster, default_url: "poster_default.png"
  validates_attachment_content_type :poster, content_type: %r{\Aimage/.*\Z}
end
