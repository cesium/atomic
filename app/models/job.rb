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

  scope :filter_position, ->(position) { where("lower(position) like ?", "#{position.downcase}%") }
  scope :filter_company, ->(company) { where("lower(company) like ?", "#{company.downcase}%") }
  scope :filter_location, ->(location) { where("lower(location) like ?", "#{location.downcase}%") }
  scope :filter_between, ->(start_date, end_date) { where("created_at BETWEEN ? AND ?", start_date.to_date, end_date.to_date) }

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    tags.map(&:name).join(", ")
  end

  def self.filters(jobs, params)
    jobs = jobs.filter_between(params[:filter_start_date], params[:filter_end_date]) if Job.between?(params)

    Job.filtering_params(params).each do |key, value|
      jobs = jobs.public_send(key, value) if value.present?
    end

    jobs
  end

  def self.filtering_params(params)
    params.slice(:filter_position, :filter_company, :filter_location)
  end

  def self.between?(params)
    Date.parse params[:filter_start_date]
    Date.parse params[:filter_end_date]
  rescue ArgumentError, TypeError
    false
  end
end
