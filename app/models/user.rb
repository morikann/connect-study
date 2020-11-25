class User < ApplicationRecord
  attr_accessor :current_password
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following


  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(follower_id: other_user.id).destroy 
  end

  def following?(other_user)
    following.include?(other_user)
  end

end
