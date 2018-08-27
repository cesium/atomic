class Job < ApplicationRecord
  has_many :job_taggings
  has_many :tags, through: :job_taggings

  validates :position, presence: true
  validates :company, presence: true

  validates :link, format: {
    with: %r{\A(http|https)://.*\z},
    message: " is invalid, make sure your Link starts with http:// or https://"
  }

  has_attached_file :poster, default_url: "poster_default.png"
  validates_attachment_content_type :poster, content_type: %r{\Aimage\/.*\Z}

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    tags.map(&:name).join(", ")
  end
end
