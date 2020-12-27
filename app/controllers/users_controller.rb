class UsersController < ApplicationController
  before_action :authenticate_user!

  def index 
    @users = User.includes(profile: :tags).search(search_params).page(params[:page])
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

  private 

  def search_params 
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end

end
