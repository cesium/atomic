class Activity < ApplicationRecord
  has_many :registrations
  has_many :participants, through: :registrations, source: :user
  has_many :activities, class_name: "Activity", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Activity", optional: true

  validates :name, presence: true, length: { maximum: 75 }
  validates :location, presence: true
  validates :description, presence: true
  validates :number_participants, presence: true, numericality: true
  validates :speaker, length: { maximum: 75 }
  validates :member_cost, presence: true, numericality: true
  validates :guest_cost,  presence: true, numericality: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_is_after_start_date, unless: :nil_dates?

  has_attached_file :poster, default_url: "poster_default.png"
  validates_attachment_content_type :poster, content_type: %r{\Aimage\/.*\Z}

  scope :next_activities, lambda {
    where("? < activities.end_date", Time.current)
      .order("start_date ASC")
  }

  scope :previous_activities, lambda {
    where("? > activities.end_date", Time.current)
      .order("start_date DESC")
  }

  def end_date_is_after_start_date
    errors.add(:end_date, "end_date must occur after start_date") if end_date < start_date
  end

  def already_happened?
    end_date < Time.current
  end

  def registered?(user)
    registrations.find_by(user_id: user.id)
  end

  def can_register?
    number_participants == 0 || participants.count < number_participants
  end

  private

  def nil_dates?
    start_date.nil? || end_date.nil?
  end
end
