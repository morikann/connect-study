class Location < ApplicationRecord
  geocoded_by :address
  has_many :study_events

  validates :address, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
