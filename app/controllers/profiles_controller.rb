class ProfilesController < ApplicationController
  before_action :prohibit_duplicate_profile, only: :new
  before_action :correct_user, only: [:edit, :update]
  skip_before_action :registration_profile, only: [:new, :create]

  def new
    @user_profile = current_user.build_profile
  end

  def edit
    @user = Profile.find(params[:id]).user
    @user_profile = @user.profile
    @tag_list = @user_profile.tags.pluck(:name).join(' ')
  end

  def create
    @user_profile = current_user.build_profile(profile_params)
    tag_list = params[:profile][:tag].split(' ')
    if @user_profile.save
      @user_profile.save_tags(tag_list)
      flash[:notice] = "プロフィールの設定が完了しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user = Profile.find(params[:id]).user
    @user_profile = @user.profile
    tag_list = params[:profile][:tag].split(' ')
    if @user_profile.update(profile_params)
      @user_profile.save_tags(tag_list)
      flash[:notice] = "プロフィールの変更が完了しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def show
    @user = Profile.find(params[:id]).user
    @user_profile = @user.profile
  end

  private

  def profile_params
    params.require(:profile).permit(:avatar, :birth_date, :purpose, :self_introduction, :username, :prefecture_id)
  end

  def prohibit_duplicate_profile
    if current_user.profile
      flash[:alert] = "すでにプロフィールの登録は完了しています"
      redirect_to root_url
    end
  end

  def correct_user
    @user = Profile.find(params[:id]).user
    redirect_to root_url unless @user == current_user
  end

end
