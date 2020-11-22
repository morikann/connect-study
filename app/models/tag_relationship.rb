class TagRelationship < ApplicationRecord
  belongs_to :profile
  belongs_to :tag

  validates :tag_id, presence: true
  validates :profile_id, presence: true
end
