class StudyEvent < ApplicationRecord
  belongs_to :location, optional: true

  belongs_to :user

  has_many :event_users
  has_many :users, through: :event_users

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :begin_time, presence: true
  validates :finish_time, presence: true
  validates :date, presence: true

  mount_uploader :image, ImageUploader
end
