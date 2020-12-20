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
    @location = Location.new(location_params)
    if @location.valid?
      results = Geocoder.search(location_params[:address])
      latitude = results.first.coordinates[0]
      longitude = results.first.coordinates[1]
      session[:location_name] = location_params[:name]
      session[:location_address] = location_params[:address]
      session[:location_latitude] = latitude
      session[:location_longitude] = longitude
      redirect_to event_user_path
    else
      render 'new'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :latitude, :longitude, :address) 
  end
end
