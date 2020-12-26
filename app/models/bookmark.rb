class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :study_event

  validates :user_id, uniqueness: { scope: :study_event_id }
end
