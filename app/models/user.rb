class User < ApplicationRecord
  attr_accessor :current_password
  
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

  has_many :event_users
  has_many :study_events, through: :event_users

  has_many :my_study_events, class_name: "StudyEvent"

  default_scope -> { order(created_at: :desc) }

  def self.search(search_word)
    self.joins(profile: :tags).where(tags: {name: search_word})
    # User.joins(profile: :tags).where(tags: {name: search_word})
    # joins(profile: :tags).where('name LIKE ?', "%#{search_word}%")
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

  def matchers
    self.followers && self.following 
  end

  def matchers_profile
    self.matchers.includes(:profile).map { |user| user.profile }
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

end
