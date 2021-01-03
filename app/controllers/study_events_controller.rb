class StudyEventsController < ApplicationController
  def index
    @study_events = StudyEvent.includes(:location, :tags, user: :profile).search(search_params)
  end

  def new  #step1
    # 初めての入力か、戻るボタンからきたかを判断してインスタンスをつくる
    params[:study_event] ? @study_event = StudyEvent.new(study_event_params) : @study_event = StudyEvent.new
  end

  def edit
    @study_event = StudyEvent.find(params[:id])
    gon.tag_list = @study_event.tags
    # @tag_list = @study_event.tags.pluck(:name).join(' ')
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
    study_event = StudyEvent.find(params[:id])
    tag_list = study_event_params[:tag].split(',')
    if study_event.update(study_event_params)
      study_event.save_tags(tag_list)
      flash[:notice] = '勉強会の更新が完了しました'
      redirect_to profile_path(current_user)
    else
      render 'edit'
    end
  end

  def show
    @study_event = StudyEvent.find(params[:id])
    gon.latitude = @study_event.location.latitude 
    gon.longitude = @study_event.location.longitude
    @notification = Notification.new
  end

  def destroy
    study_event = StudyEvent.find(params[:id])
    study_event.destroy 
    redirect_to profile_path(current_user), notice: '勉強会を削除しました'
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

    gon.latitude = session[:location]['latitude'] if session[:location]
    gon.longitude = session[:location]['longitude'] if session[:location]

    @prefecture = Prefecture.find(session[:location]['prefecture_id'].to_i).name if session[:location]
    render 'confirm'
  end

  def check_confirm
    if params[:back]
      return redirect_to step3_path(study_event: study_event_params)
    end

    location = Location.create(session[:location])

    @study_event = current_user.my_study_events.build(study_event_params)
    @study_event.location_id = location.id
    @study_event.image.retrieve_from_cache!(session[:image_cache_name]) if session[:image_cache_name]
    @study_event.save if @study_event.valid?
    tag_list = study_event_params[:tag].split(',')
    @study_event.save_tags(tag_list)
    
    room = @study_event.create_room
    Entry.create(user_id: current_user.id, room_id: room.id)

    @study_event.event_users.create(user_id: current_user.id)

    # 招待したユーザーを勉強会とそのチャットグループに参加させる
    if session[:event_users]
      session[:event_users].each do |user_id| 
        @study_event.event_users.create(user_id: user_id) 
        Entry.create(user_id: user_id, room_id: room.id)
      end
    end

    # 招待したユーザーに通知を送る
    @study_event.create_notification_invite_user!(current_user, session[:event_users]) if session[:event_users]

    session.delete(:location)
    session.delete(:image_cache_name)
    session.delete(:image_url)
    session.delete(:event_users)

    redirect_to study_events_path, notice: "勉強会「#{@study_event.name}」を作成しました"
  end

  private

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :tag, :image) 
  end

  def search_params
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end
end
