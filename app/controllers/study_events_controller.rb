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
      session[:study_event_name] = study_event_params[:name]
      session[:study_event_image] = study_event_params[:image]
      session[:study_event_description] = study_event_params[:description]
      session[:study_event_date] = study_event_params[:date]
      session[:study_event_display_range] = study_event_params[:display_range]
      session[:study_event_begin_time] = study_event_params[:begin_time]
      session[:study_event_finish_time] = study_event_params[:finish_time]
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
    # @event_user = EventUser.new
    render 'event_user'
  end

  def confirm_event_user
    # @event_user = EventUser.new(event_user_params)
      session[:event_user] = event_user_params
      redirect_to confirm_path
  end

  def confirm 
    gon.latitude = session[:location_latitude]
    gon.longitude = session[:location_longitude]
    render 'confirm'
  end

  def check_confirm
    location = Location.create(
      name: session[:location_name],
      address: session[:location_address],
      latitude: session[:location_latitude],
      longitude: session[:location_longitude]
    )
    study_event = current_user.my_study_events.create(
      name: session[:study_event_name],
      image: session[:study_event_image],
      description: session[:study_event_description],
      display_range: session[:study_event_display_range],
      date: session[:study_event_date],
      begin_time: session[:study_event_begin_time],
      finish_time: session[:study_event_finish_time],
      location_id: location.id
    )
    event_user_profile_id = session[:event_user].reject(&:blank?)
    event_user_profile_id.each do |id|
      EventUser.create(
        user_id: id.to_i,
        study_event_id: study_event.id
      )
    end
    EventUser.create(user_id: current_user.id, study_event_id: study_event.id)
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
