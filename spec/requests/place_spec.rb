require 'rails_helper'
require 'rspec/active_model/mocks'


RSpec.describe 'Place API', type: :request do
  
    describe 'POST /v1/places' do

        let(:place) { build_stubbed(:place, latitude: -33.8670522, longitude: 151.1957362 ) }  

        let(:latitude) { place.latitude }
        let(:longitude) { place.longitude}
        let(:valid_attributes) { { latitude: latitude , longitude: longitude } }

        context 'when the request is valid' do
            before { post '/v1/places/', params: valid_attributes }

            it 'searches a place' do
                expect(json['message']).to eq('Successfully retrieved record from Google Places')
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the request is invalid' do
            before { post '/v1/places/', params: { latitude: 33.8670522 } }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(response.body)
                .to match(/Validation failed: Longitude can't be blank/)
            end
        end
    end
end

