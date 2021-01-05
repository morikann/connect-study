class LocationsController < ApplicationController
  def new  #step2
    @location = Location.new(session[:location] || {})
    # step2のurlを直接打ち込まれた際にエラーが生じないようにする
    @study_event = StudyEvent.new(study_event_params) if params[:study_event]
  end

  def create 
    if params[:back]
      # get '/step1', to: 'study_events#new'
      return redirect_to step1_path(study_event: study_event_params)
    end

    results = Geocoder.search(location_params[:address])
    if results.first
      latitude = results.first.coordinates[0]
      longitude = results.first.coordinates[1]
    end
    
    @location = Location.new(
      name: location_params[:name],
      address: location_params[:address],
      prefecture_id: location_params[:prefecture_id],
      latitude: latitude,
      longitude: longitude
    )

    if @location.valid?
      session[:location] = @location.attributes.slice('name', 'address', 'latitude', 'longitude', 'prefecture_id')
      # get '/step3', to: study_events#event_user
      redirect_to step3_url(study_event: study_event_params)
    else
      flash[:alert] = @location.errors.full_messages
      redirect_to step2_path(study_event: study_event_params)
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :prefecture_id) 
  end

  def study_event_params
    params.require(:study_event).permit(:name, :description, :date, :display_range, :begin_time, :finish_time, :tag, :image) 
  end
end
