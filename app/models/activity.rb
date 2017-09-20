class Activity < ActiveRecord::Base
  has_many :registrations
  has_many :participants, through: :registrations,
                          source: :user
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
  validate :end_date_is_after_start_date
  has_attached_file :poster, default_url: "/images/logo.png"
  validates_attachment_content_type :poster, content_type: /\Aimage\/.*\Z/

  scope :next_activities, -> {
    order('start_date DESC').
    limit(5).
    where("activities.end_date >= ?", Time.now)
  }

  def end_date_is_after_start_date
    if end_date < start_date
      errors.add(:end_date, "end_date must occur after start_date")
    end
  end

  def registered?(user)
    registrations.find_by(user_id: user.id)
  end
end
