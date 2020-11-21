class User < ApplicationRecord
  attr_accessor :current_password
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # mount_uploader :avatar, AvatarUploader

  has_one :profile, dependent: :destroy
end
