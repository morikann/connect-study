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

  def search_user
    user = User.find(current_user.id)
    latitude, longitude = params[:latitude], params[:longitude]
    results = Geocoder.search([latitude, longitude])
    address = results.first.address
    if user.update(address: address, latitude: latitude, longitude: longitude)
      @users = User.near([latitude, longitude], 5, units: :km).page(params[:page])
    else
      flash[:alert] = '検索に失敗しました'
      render 'index'
    end
  end

  private 

  def search_params 
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end

end
