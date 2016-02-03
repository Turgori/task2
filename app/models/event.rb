class Event < ActiveRecord::Base
  TYPES = [:once, :daily, :weekly, :monthly, :yearly]

  belongs_to :user
  enum event_type: TYPES

  scope :type, ->(type) { where(event_type: event_types[type]) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :visible, ->(user_id) { where("user_id = ? OR private = false", user_id) }

  def self.once(start_day, end_day)
    type(:once).where(date: start_day..end_day)
  end

  def self.yearly(month)
    type(:yearly).where("date_part('month', date) = ?", month)
  end

  def self.simple_types
    [:daily, :weekly, :monthly]
  end
end
