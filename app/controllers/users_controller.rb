class UsersController < ApplicationController
  before_action :authenticate_user!

  def index 
    if params[:search].present?
      @users = User.includes(profile: :tags).search(params[:search]).page(params[:page])
    else
      @users = User.includes(profile: :tags).page(params[:page])
    end
  end

  def following
    @title = 'フォロー中'
    @user = User.find(params[:id])
    @users = @user.following.includes(profile: :tags).page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user = User.find(params[:id])
    @users = @user.followers.includes(profile: :tags).page(params[:page])
    render 'show_follow'
  end

end
