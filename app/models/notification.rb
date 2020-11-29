class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true

  default_scope -> { order(created_at: :desc) }
end
