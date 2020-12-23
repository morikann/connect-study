class LocationsController < ApplicationController
  def new
    @location = Location.new(session[:location] || {})
  end

  def create 
    if params[:back]
      return redirect_to step1_path
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
      redirect_to step3_url
    else
      render 'new'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :prefecture_id) 
  end
end
