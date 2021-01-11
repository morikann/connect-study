class StudyEvent < ApplicationRecord
  attr_accessor :tag

  default_scope -> { order(created_at: :desc) }

  has_one :location, dependent: :destroy

  belongs_to :user

  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  has_many :event_tags, dependent: :destroy 
  has_many :tags, through: :event_tags

  has_many :bookmarks, dependent: :destroy 
  has_many :bookmark_users, through: :bookmarks, source: :user

  has_many :notifications, dependent: :destroy

  has_one :room, dependent: :destroy

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

  # simple_calendar gem の設定
  def start_time
    self.date 
  end

  # def end_time
  #   self.date 
  # end

  def correct_begin_time 
    self.begin_time.strftime("%H:%M")
  end

  def correct_finish_time
    self.finish_time.strftime("%H:%M")
  end

  scope :search, -> (search_params) do
    return if search_params.blank?

    tag_like(search_params[:tag]).prefecture_id_is(search_params[:prefecture_id])
  end

  scope :tag_like, -> (tag) do
    self.joins(:tags).where('tags.name LIKE ?', "%#{tag}%") if tag.present?
  end

  scope :prefecture_id_is, -> (prefecture_id) do
    self.joins(:location).where(locations: { prefecture_id: prefecture_id }) if prefecture_id.present?
  end

  def create_notification_bookmark!(current_user)
    # すでにブックマークされているか検索
    temp = Notification.where(
      "visitor_id = ? and visited_id = ? and study_event_id = ? and action = ?", current_user.id, user_id, id, 'bookmark'
    )
    # ブックマークされていない場合のみ通知を作成
    if temp.blank?
      notification = current_user.active_notifications.build(
        visited_id: user_id,
        study_event_id: id,
        action: 'bookmark'
      )
      # 自分の勉強会に対するブックマークは通知を作成しない
      unless notification.visited_id == notification.visitor_id
        notification.save if notification.valid?
      end
    end
  end

  def create_notification_invite_user!(current_user, invite_user_ids)
    # 招待したユーザー全員に通知を送る
    invite_user_ids.each do |invite_user_id|
      save_notification_invite_user!(current_user, invite_user_id)
    end
  end

  def save_notification_invite_user!(current_user, invite_user_id)
    notification = current_user.active_notifications.build(
      study_event_id: id,
      visited_id: invite_user_id,
      action: 'invite'
    )
    notification.save if notification.valid?
  end

  def create_notification_exit_user!(current_user, study_event_owner_id)
    notification = current_user.active_notifications.build(
      study_event_id: id,
      visited_id: study_event_owner_id,
      action: 'exit_the_event'
    )
    notification.save if notification.valid?
  end

end
