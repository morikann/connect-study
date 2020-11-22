class Profile < ApplicationRecord
  belongs_to :user
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships

  validates :username, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :prefecture_id, presence: true
  validates :purpose, presence: true, length: { maximum: 30 }
  validates :birth_date, presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  mount_uploader :avatar, AvatarUploader

  def save_tags(tags)
    tags.each do |new_tag|
      profile_tag = Tag.find_or_create_by(name: new_tag)
      self.tags << profile_tag
    end
  end
end
