class Partner < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 75 }
  validates :description, presence: true
  has_attached_file :logo
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
end
