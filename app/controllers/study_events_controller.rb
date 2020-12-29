class StudyEventsController < ApplicationController
  def index
    @study_events = StudyEvent.includes(:location, :tags, user: :profile).search(search_params)
  end

  def new 
    @study_event = current_user.my_study_events.build(session[:study_event] || {})
  end

  def edit
    @study_event = StudyEvent.find(params[:id])
    @tag_list = @study_event.tags.pluck(:name).join(' ')
  end

  def create
    @study_event = current_user.my_study_events.build(study_event_params)
    if @study_event.valid?
      # フォームで渡された値のみ保存。ActionController::Parametersの仕様変更の可能性があるのでstudy_event_paramsをそのまま保存しない。
      session[:study_event] = @study_event.attributes.slice(*study_event_params.keys)
      # インスタンスの属性にはparamsと異なる形式の日付、時間が格納されているのでその形式を元に戻す
      session[:study_event]['date'] = session[:study_event]['date'].strftime("%Y-%m-%d")
      session[:study_event]['begin_time'] = session[:study_event]['begin_time'].strftime("%H:%M")
      session[:study_event]['finish_time']= session[:study_event]['finish_time'].strftime("%H:%M")
      session[:study_event]['tag'] = study_event_params[:tag]
      
      # 画像の変更があった場合のみ
      if @study_event.image.cache_name
        session[:image_cache_name] = @study_event.image.cache_name
        session[:image_url] = @study_event.image.url
      end
      redirect_to step2_path
    else
      render 'new'
    end
  end

  def update
    study_event = StudyEvent.find(params[:id])
    tag_list = study_event_params[:tag].split(/ |　/)
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
  end

  def destroy
    study_event = StudyEvent.find(params[:id])
    study_event.destroy 
    redirect_to profile_path(current_user), notice: '勉強会を削除しました'
  end

  def event_user
    render 'event_user'
  end

  def confirm_event_user
    if params[:back]
      return redirect_to step2_path
    end
    session[:event_users] = params[:user_ids].reject(&:blank?)
    redirect_to confirm_path
  end

  def confirm 
    gon.latitude = session[:location]['latitude'] if session[:location]
    gon.longitude = session[:location]['longitude'] if session[:location]
    @tag_list = session[:study_event]['tag'].split(/ |　/) if session[:study_event]
    @prefecture = Prefecture.find(session[:location]['prefecture_id'].to_i).name if session[:location]
    render 'confirm'
  end

  def check_confirm
    if params[:back]
      return redirect_to step3_path
    end

    location = Location.create(session[:location])

    @study_event = current_user.my_study_events.build(session[:study_event])
    @study_event.location_id = location.id
    @study_event.image.retrieve_from_cache!(session[:image_cache_name]) if session[:image_cache_name]
    @study_event.save
    tag_list = session[:study_event]['tag'].split(/ |　/)
    @study_event.save_tags(tag_list)
    
    @study_event.event_users.create(user_id: current_user.id)
    session[:event_users].each { |user_id| @study_event.event_users.create(user_id: user_id) }

    # 招待したユーザーに通知を送る
    @study_event.create_notification_invite_user!(current_user, session[:event_users]) if session[:event_users]

    session.delete(:study_event)
    session.delete(:location)
    session.delete(:image_cache_name)
    session.delete(:image_url)
    session.delete(:event_users)

    redirect_to study_events_path
  end

  private

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :tag, :image) 
  end

  def search_params
    params.fetch(:search, {}).permit(:tag, :prefecture_id)
  end
end
