class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # room_idは一つのuser_idに対して一つだけ
  # 同じユーザーが同じルームに二回以上入るのを防ぐ。
  validates :room_id, uniqueness: { scope: :user_id }
end
