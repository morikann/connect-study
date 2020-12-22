class StudyEventsController < ApplicationController
  def index
    @study_events = StudyEvent.all 
  end

  def new 
    @study_event = current_user.my_study_events.build(session[:study_event] || {})
  end

  def edit 
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
  end

  def show
  end

  def destroy
  end

  def event_user
    render 'event_user'
  end

  def confirm_event_user
    if params[:back]
      return redirect_to step2_path
    end

    session[:event_user] = params[:user_id]
    redirect_to confirm_path
  end

  def confirm 
    gon.latitude = session[:location]['latitude'] if session[:location]
    gon.longitude = session[:location]['longitude'] if session[:location]
    render 'confirm'
  end

  def check_confirm
    if params[:back]
      return redirect_to step3_path
    end

    location = Location.create(
      name: session[:location]['name'],
      address: session[:location]['address'],
      latitude: session[:location]['latitude'],
      longitude: session[:location]['longitude']
    )

    study_event = current_user.my_study_events.build(session[:study_event])
    study_event.location_id = location.id
    study_event.image.retrieve_from_cache!(session[:image_cache_name]) if session[:image_cache_name]
    study_event.save

    event_user_profile_id = session[:event_user].reject(&:blank?)
    event_user_profile_id.each do |id|
      EventUser.create(
        user_id: id.to_i,
        study_event_id: study_event.id
      )
    end
    EventUser.create(user_id: current_user.id, study_event_id: study_event.id)

    session.delete(:study_event)
    session.delete(:location)
    session.delete(:image_cache_name)
    session.delete(:image_url)
    session.delete(:event_user)

    redirect_to study_events_path
  end

  private

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :image) 
  end
end
