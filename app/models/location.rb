class Location < ApplicationRecord
  geocoded_by :address
  has_many :study_events

  validates :address, presence: true
end
