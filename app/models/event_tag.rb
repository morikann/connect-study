class EventTag < ApplicationRecord
  belongs_to :tag
  belongs_to :study_event
end
