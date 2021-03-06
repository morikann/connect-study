class User < ApplicationRecord
  attr_accessor :current_password

  # geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  has_many :active_notifications, class_name: "Notification", foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: :visited_id, dependent: :destroy

  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries

  has_many :messages, dependent: :destroy

  has_many :event_users, dependent: :destroy
  has_many :study_events, through: :event_users
 
  has_many :my_study_events, class_name: "StudyEvent", dependent: :destroy

  has_many :bookmarks, dependent: :destroy 
  has_many :bookmark_events, through: :bookmarks, source: :study_event

  has_many :active_reports, class_name: "Report", foreign_key: :reporter_user_id, dependent: :destroy 
  has_many :passive_reports, class_name: "Report", foreign_key: :reported_user_id, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  scope :search_user_click_tag, -> (tag) do
    self.joins(profile: :tags).where(tags: {name: tag})
  end

  scope :search_user, -> (search_params) do
    return if search_params.blank?

    tag_like(search_params[:tag]).prefecture_id_is(search_params[:prefecture_id])
  end

  scope :tag_like, -> (tag) do
    self.joins(profile: :tags).where('tags.name LIKE ?', "%#{tag}%") if tag.present?
  end

  scope :prefecture_id_is, -> (prefecture_id) do
    self.joins(:profile).where(profiles: { prefecture_id: prefecture_id }) if prefecture_id.present?
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(follower_id: other_user.id).destroy 
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  # 相互フォロワー(積集合)
  def matchers
    self.followers.includes(:profile) & self.following.includes(:profile)
  end

  def matcher?(other_user)
    followers.include?(other_user) & following.include?(other_user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, self.id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.build(
        visited_id: self.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def create_notification_message_room!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, self.id, 'DM'])
    if temp.blank?
      notification = current_user.active_notifications.build(
        visited_id: self.id,
        action: 'DM'
      )
      notification.save if notification.valid?
    end
  end

  def bookmark?(study_event)
    bookmark_events.include?(study_event)
  end

  def bookmark(study_event)
    bookmark_events << study_event 
  end

  def delete_bookmark(study_event)
    bookmarks.find_by(study_event_id: study_event.id).destroy 
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def create_guest_profile
    create_profile!(
      username: 'ゲストユーザー',
      purpose: 'ポートフォリオの閲覧',
      prefecture_id: 10,
      self_introduction: '審査',
      "birth_date(1i)"=>"2000",
      "birth_date(2i)"=>"8",
      "birth_date(3i)"=>"8",
      tag: 'プログラミング'
    )
  end

end
