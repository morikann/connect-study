class Profile < ApplicationRecord
  belongs_to :user

  validates :username, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :prefecture_id, presence: true
  validates :purpose, presence: true, length: { maximum: 30 }
  validates :birth_date, presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  mount_uploader :avatar, AvatarUploader

end
