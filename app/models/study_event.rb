class StudyEvent < ApplicationRecord
  belongs_to :location

  has_many :event_users
  has_many :users, through: :event_users

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :display_range, presence: true
  validates :begin_time, presence: true
  validates :finish_time, presence: true
  validates :date, presence: true
end
