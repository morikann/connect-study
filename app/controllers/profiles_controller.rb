class ProfilesController < ApplicationController
  before_action :prohibit_duplicate_profile, only: :new
  before_action :correct_user, only: %i[edit update]
  before_action :set_profile, only: %i[edit update]
  skip_before_action :registration_profile, only: %i[new create]

  def new
    @user_profile = current_user.build_profile
  end

  def edit
    gon.tag_list = @user_profile.tags
  end

  def create
    @user_profile = current_user.build_profile(profile_params)
    tag_list = profile_params[:tag].split(',')
    if @user_profile.save
      @user_profile.save_tags(tag_list)
      flash[:notice] = "プロフィールの設定が完了しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    tag_list = profile_params[:tag].split(',')
    if @user_profile.update(profile_params)
      @user_profile.save_tags(tag_list)
      flash[:notice] = "プロフィールの変更が完了しました"
      redirect_to profile_url(@user_profile)
    else
      render 'edit'
    end
  end

  def show
    @user = Profile.find(params[:id]).user
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless current_user.id == @user.id 
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          # 同じトークルームかつそのトークルームが個人メッセージルームの時のみ(勉強会のグループは含まない)
          if cu.room_id == u.room_id && cu.room.study_event_id == nil
            @isRoom = true
            @room_id = cu.room_id 
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
    @my_study_events = @user.my_study_events
    @report = current_user.active_reports.build
  end

  private

  def profile_params
    params.require(:profile).permit(:avatar, :birth_date, :purpose, :self_introduction, :username, :prefecture_id, :tag)
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

  def set_profile
    @user_profile = Profile.find(params[:id])
  end

end
