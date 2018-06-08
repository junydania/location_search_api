class V1::PlacesController < ApplicationController    
    before_action :validate_google_api


    def search_places
        place = Place.new(places_params)
        latitude, longitude, query, provider = place.latitude, place.longitude, place.query, place.provider
        if provider.nil? || provider.titleize == "Google" || provider.titleize == "Google Places" 
            search_google(latitude, longitude, query, provider)
        elsif provider.titleize == "Yelp"
            search_yelp
        elsif provider.titleize == "Foursquare"
            search_foursquare
        else
            search_google(latitude, longitude, query)
        end
    end

    
    private

    def search_yelp
        render status: 200, json: {
                message: "Yelp not yet setup, use Google as the provider for now",
            }
    end

    def search_foursquare
        render status: 200, json: {
            message: "Foursquare not yet setup, use Google as the provider for now",
        }
    end

    def search_google(latitude, longitude, query, provider)
        unless latitude.nil? && longitude.nil?
            float_latitude = latitude.to_f
            float_longitude = longitude.to_f
            if param_value_is_valid?(float_latitude, float_longitude) == true
                locations = @client.spots(float_latitude, float_longitude, detail: true)
                return_data(locations, provider)
            else
                render status: 422, json: {
                    message: "Wrong data type passed to latitude or longitude param",
                }
            end
        end         
        if !query.nil?
            locations = @client.spots_by_query(query, detail: true)
            return_data(locations, provider)
        else
            render status: 400, json: {
                message: "No params provided",
            }
        end
    end


    def validate_google_api
        @client = GooglePlaces::Client.new(ENV["GOOGLE_API_KEY"])
    end


    def param_value_is_valid?(latitude, longitude)
        if latitude != 0.0 || longitude != 0.0
            return true
        else
            return false
        end       
    end


    def return_data(locations, provider)
        if locations.any?
            google_record = Array.new
            locations.each do |location| 
                data = { ID: location.id, Provider: provider, Name: location.name, Description:location.types.join(","), 
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
        params.require(:place).permit(:latitude, :longitude, :query, :provider)
    end

end
