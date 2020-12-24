class StudyEvent < ApplicationRecord
  attr_accessor :tag

  belongs_to :location, optional: true

  belongs_to :user

  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  has_many :event_tags, dependent: :destroy 
  has_many :tags, through: :event_tags

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :begin_time, presence: true
  validates :finish_time, presence: true
  validates :date, presence: true
  validates :tag, presence: true

  mount_uploader :image, ImageUploader

  def save_tags(event_tag)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - event_tag
    new_tags = event_tag - current_tags

    # 古いタグを削除
    old_tags.each do |old_tag|
      self.tags.delete(Tag.find_by(name: old_tag))
    end

    # 新しいタグを追加
    new_tags.each do |new_tag|
      add_tag = Tag.find_or_create_by(name: new_tag)
      self.tags << add_tag
    end
  end
end
