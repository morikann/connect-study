class StudyEventsController < ApplicationController
  before_action :set_study_event, only: %i[edit update show destroy]

  def index
    @study_events = StudyEvent.includes(:location, :event_tags, user: :profile).search_event(search_params).page(params[:page])
  end

  def new  #step1
    # 初めての入力か、戻るボタンからきたかを判断してインスタンスをつくる
    params[:study_event] ? @study_event = StudyEvent.new(study_event_params) : @study_event = StudyEvent.new
  end

  def edit
    gon.tag_list = @study_event.tags
  end

  def create
    @study_event = current_user.my_study_events.build(study_event_params)
    if @study_event.valid?
      # # 画像の変更があった場合のみ
      if @study_event.image.cache_name
        session[:image_cache_name] = @study_event.image.cache_name
        session[:image_url] = @study_event.image.url
      end
      # get '/step2', to: locations#new
      redirect_to step2_path(study_event: study_event_params)
    else
      render 'new'
    end
  end

  def update
    tag_list = study_event_params[:tag].split(',')
    if @study_event.update(study_event_params)
      @study_event.save_tags(tag_list)
      flash[:notice] = '勉強会の更新が完了しました'
      redirect_to profile_path(current_user.profile)
    else
      render 'edit'
    end
  end

  def show
    gon.latitude = @study_event.location.latitude 
    gon.longitude = @study_event.location.longitude
    @notification = Notification.new
  end

  def destroy
    @study_event.destroy 
    redirect_to profile_path(current_user.profile), notice: '勉強会を削除しました'
  end

  def event_user
    # step3のurlを直接打ち込まれた際にエラーが生じないようにする
    @study_event = StudyEvent.new(study_event_params) if params[:study_event]
    render 'event_user'
  end

  def confirm_event_user
    if params[:back]
      # get '/step2', to: locations#new
      return redirect_to step2_path(study_event: study_event_params)
    end
    session[:event_users] = params[:user_ids].reject(&:blank?)
    redirect_to confirm_path(study_event: study_event_params)
  end

  def confirm 
    # confirmのurlを直接打ち込まれた際にエラーが生じないようにする
    if params[:study_event]
      @study_event = StudyEvent.new(study_event_params)
      @tag_list = study_event_params[:tag].split(',')
    end

    if session[:location]
      gon.latitude = session[:location]['latitude']
      gon.longitude = session[:location]['longitude']
      @prefecture = Prefecture.find(session[:location]['prefecture_id'].to_i).name
    end

    render 'confirm'
  end

  def check_confirm
    if params[:back]
      return redirect_to step3_path(study_event: study_event_params)
    end

    study_event = current_user.my_study_events.build(study_event_params)
    # @study_event.location_id = location.id
    study_event.image.retrieve_from_cache!(session[:image_cache_name]) if session[:image_cache_name]

    if study_event.save
      tag_list = study_event_params[:tag].split(',')
      study_event.save_tags(tag_list)

      study_event.create_location(session[:location])
      
      room = study_event.create_room
      Entry.create(user_id: current_user.id, room_id: room.id)

      study_event.event_users.create(user_id: current_user.id)

      # 招待したユーザーを勉強会とそのチャットグループに参加させる
      if session[:event_users]
        session[:event_users].each do |user_id| 
          study_event.event_users.create(user_id: user_id) 
          Entry.create(user_id: user_id, room_id: room.id)
        end
      end

      # 招待したユーザーに通知を送る
      study_event.create_notification_invite_user!(current_user, session[:event_users]) if session[:event_users]

      session.delete(:location)
      session.delete(:image_cache_name)
      session.delete(:image_url)
      session.delete(:event_users)

      redirect_to study_events_path, notice: "勉強会「#{study_event.name}」を作成しました"
    else
      redirect_to confirm_path(study_event: study_event_params), alert: "入力に誤りがあります"
    end
  end

  def exit_the_event
    if current_user.id == event_exit_params[:study_event_owner_id].to_i
      redirect_to room_path(event_exit_params[:room_id]), alert: "主催者は勉強会を退会することはできません。"
    else
      study_event = StudyEvent.find(event_exit_params[:study_event_id])
      event_user = EventUser.find_by(user_id: current_user.id, study_event_id: event_exit_params[:study_event_id])
      entry = Entry.find_by(user_id: current_user.id, room_id: event_exit_params[:room_id])
      if event_user.destroy
        if entry.destroy
          # 勉強会の主催者に抜けたことを通知
          study_event.create_notification_exit_user!(current_user, event_exit_params[:study_event_owner_id])
          redirect_to rooms_path, notice: "勉強会「#{study_event.name}」を退会しました。"
        else
          redirect_to root_path, alert: "勉強会のチャットルームからの退出に失敗しました。"
        end
      else
        redirect_to root_path, alert: "勉強会の退会に失敗しました。"
      end
    end
  end

  private

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :tag, :image) 
  end

  def search_params
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end

  def event_exit_params
    params.require(:exit_the_event).permit(:study_event_owner_id, :study_event_id).merge(room_id: params[:id])
  end

  def set_study_event
    @study_event = StudyEvent.find(params[:id])
  end
end
