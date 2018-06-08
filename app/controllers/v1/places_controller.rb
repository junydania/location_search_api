class V1::PlacesController < ApplicationController
    
    before_action :validate_google_api
    
    API_KEY = 'AIzaSyBZJUXtq2chEn3x6jAAlL3cwmASuca7oK0'
    
    def search_places
        place = Place.new(places_params)
        latitude, longitude, query = place.latitude, place.longitude, place.query
        unless latitude.nil? && longitude.nil?
            latitude = place.latitude.to_f
            longitude = place.longitude.to_f
            if param_value_is_valid?(latitude, longitude) == true
                locations = @client.spots(latitude, longitude, detail: true)
                return_data(locations)
            else
                render status: 422, json: {
                    message: "Wrong data type passed to latitude or longitude param",
                }
            end
        end         
        if !query.nil?
            locations = @client.spots_by_query(query, detail: true)
            return_data(locations)
        else
            render status: 400, json: {
                message: "No params provided",
            }
        end
    end

   
    private

    def validate_google_api
        @client = GooglePlaces::Client.new(API_KEY)
        @provider = "Google Places"
    end

    def param_value_is_valid?(latitude, longitude)
        if latitude != 0.0 || longitude != 0.0
            return true
        else
            return false
        end       
    end

    def return_data(locations)
        if locations.any?
            google_record = Array.new
            locations.each do |location| 
                data = { ID: location.id, Provider: @provider, Name: location.name, Description:location.types.join(","), 
                        Address: location.formatted_address, URI: location.url  }
                google_record << data
            end
            render status: 200, json: {
                message: "Successfully retrieved record from Google Places",
                places: google_record
            }
        else
            render status: 422, json: {
                message: "Wrong or Incomplete query provided",
            }
        end
    end

    def places_params
        params.require(:place).permit(:latitude, :longitude, :query)
    end
    
end
