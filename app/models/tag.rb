class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :profiles, through: :tag_relationships

  has_many :event_tags, dependent: :destroy 
  has_many :study_events, through: :event_tags

  validates :name, presence: true, uniqueness: { case_sensitive: true }

end
