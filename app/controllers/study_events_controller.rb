class StudyEventsController < ApplicationController
  def index
    @study_events = StudyEvent.all 
  end

  def new 
    @study_event = current_user.my_study_events.build
  end

  def edit 
  end

  def create
    @study_event = current_user.my_study_events.build(study_event_params)
    if @study_event.valid?
      session[:study_event] = study_event_params
      session[:study_event_name] = study_event_params[:name]
      session[:study_event_description] = study_event_params[:description]
      session[:study_event_date] = study_event_params[:date]
      session[:study_event_begin_time] = study_event_params[:begin_time]
      session[:study_event_finish_time] = study_event_params[:finish_time]
      session[:image_cache_name] = @study_event.image.cache_name
      session[:image_url] = @study_event.image.url
      redirect_to new_location_path
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
      return redirect_to new_location_path
    end

    session[:event_user] = event_user_params
    redirect_to confirm_path
  end

  def confirm 
    gon.latitude = session[:latitude]
    gon.longitude = session[:longitude]
    render 'confirm'
  end

  def check_confirm
    if params[:back]
      return redirect_to event_user_path
    end

    location = Location.create(
      name: session[:location_name],
      address: session[:location_address],
      latitude: session[:latitude],
      longitude: session[:lontitude]
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
    session.delete(:study_event_name)
    session.delete(:study_event_description)
    session.delete(:study_event_date)
    session.delete(:study_event_begin_time)
    session.delete(:study_event_finish_time)
    session.delete(:image_cache_name)
    session.delete(:image_url)
    session.delete(:location_name)
    session.delete(:location_address)
    session.delete(:latitude)
    session.delete(:longitude)
    session.delete(:event_user)

    redirect_to study_events_path
  end

  private

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :image) 
  end

  def event_user_params
    params.require(:user_id)
  end
end
