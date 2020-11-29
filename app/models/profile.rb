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

  def save_tags(profile_tag)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - profile_tag
    new_tags = profile_tag - current_tags

    # 古いタグを削除
    old_tags.each do |old_tag|
      self.tags.delete(Tag.find_by(name: old_tag))
    end

    # 新しいタグを追加
    new_tags.each do |new_tag|
      add_tag = Tag.find_or_create_by(name: new_tag)
      tags << add_tag
    end
  end

end
