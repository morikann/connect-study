class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :require_admin, only: :destroy

  def index
    @users = User.includes(profile: :tags).search(search_params).page(params[:page])
    @tags = Tag.includes(:profiles)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_url, notice: "#{user.profile.username}を削除しました。"
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
    latitude, longitude = params[:latitude], params[:longitude]
    results = Geocoder.search([latitude, longitude])
    address = results.first.address
    if current_user.update(address: address, latitude: latitude, longitude: longitude)
      @users = User.near([latitude, longitude], params[:range], units: :km).page(params[:page])
    else
      flash[:alert] = '検索に失敗しました'
      render 'index'
    end
  end

  def search_user_from_tag 
    tag_name = params[:tag_name]
    @users = User.includes(profile: :tags).where(tags: { name: tag_name })
    render :search_user
  end

  private 

  def search_params 
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end

end
