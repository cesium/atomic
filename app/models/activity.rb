class Activity < ActiveRecord::Base
  has_many :registrations
  has_many :users, through: :registrations
  has_many :activities, class_name: "Activity",
                        foreign_key: "parent_id"
  belongs_to :parent, class_name: "Activity"
  belongs_to :department

  validates :name, presence: true, length: { maximum: 75 }
  validates :location, presence: true
  validates :description, presence: true
  validates :member_cost, presence: true, numericality: true
  validates :guest_cost,  presence: true, numericality: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  has_attached_file :poster, default_url: "/images/logo.png"
 validates_attachment_content_type :poster, content_type: /\Aimage\/.*\Z/
end
