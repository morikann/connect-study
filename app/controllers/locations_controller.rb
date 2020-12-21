class LocationsController < ApplicationController
  def new
    @location = Location.new
  end

  def map 
    results = Geocoder.search(params[:address])
    @latlng = results.first.coordinates
    respond_to do |format|
      format.js
    end
  end

  def create 
    
    if params[:back]
      return redirect_to new_study_event_path
    end

    results = Geocoder.search(location_params[:address])
    latitude = results.first.coordinates[0]
    longitude = results.first.coordinates[1]
    
    @location = Location.new(
      name: location_params[:name],
      address: location_params[:address],
      latitude: latitude,
      longitude: longitude
    )
    if @location.valid?
      session[:location_name] = location_params[:name]
      session[:locaiton_address] = location_params[:address]
      session[:latitude] = latitude
      session[:longitude] = longitude
      redirect_to event_user_path
    else
      render 'new'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude) 
  end
end
