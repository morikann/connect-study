class UsersController < ApplicationController
  before_action :authenticate_user!

  # def new
  #   @user_profile = User.new
  # end

  # def create 
  #   @user_profile = User.new(profile_params)

  #   if @user_profile.save
  #     flash[:notice] = "プロフィールの設定が完了しました"
  #     redirect_to root_url
  #   else
  #     render 'new'
  #   end
  # end

  def edit 
    @user_profile = User.find(params[:id])
  end

  def update 
    @user_profile = User.find(params[:id])
    if @user_profile.update(profile_params)
      flash[:notice] = "プロフィールの設定が完了しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def show

  end

  private

  def profile_params
    params.require(:user).permit(:aim, :profile, :birth_date, :username, :prefecture_id)
  end
end
