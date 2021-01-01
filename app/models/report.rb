class Report < ApplicationRecord
  belongs_to :reporter_user, class_name: "User"
  belongs_to :reported_user, class_name: "User"

  validates :description, presence: true, length: { maximum: 200 }
end
