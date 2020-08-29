# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

describe PlacesController, type: :controller do
  let(:parsed_response_body) { JSON.parse(response.body) }
  let(:user) { create(:user) }

  before do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    request.headers.merge!(Devise::JWT::TestHelpers.auth_headers(headers, user))
  end

  describe 'GET #index' do
    context 'when success' do
      context "when there aren't places" do
        it 'returns a success response' do
          get(:index)

          expect(response).to be_successful
          expect(parsed_response_body).to eq({ 'places' => [], 'total' => 0, 'next_page' => nil })
        end
      end

      context 'when there are places' do
        let(:user2) { create(:user, email: 'veronica.silva@gmail.com') }
        let!(:marco_zero) { create(:place) }
        let!(:camaragibe) { create(:place_camaragibe, user: user2) }
        let!(:joana_bezerra) { create(:place_joana_bezerra) }

        context 'when mode list' do
          let(:expected_response) do
            {
              'places' => [
                { 'id' => camaragibe.id, 'latitude' => '-8.024639', 'longitude' => '-34.995402', 'name' => 'Camaragibe' },
                { 'id' => joana_bezerra.id, 'latitude' => '-8.073147', 'longitude' => '-34.895348', 'name' => 'Joana Bezerra' },
                { 'id' => marco_zero.id, 'latitude' => '-8.063105', 'longitude' => '-34.871084', 'name' => 'Marco Zero' }
              ],
              'total' => 3,
              'next_page' => nil
            }
          end

          it 'returns a success response' do
            get(:index)

            expect(response).to be_successful
            expect(parsed_response_body).to eq(expected_response)
          end
        end

        context 'when mode map' do
          let(:map_params) do
            {
              mode: 'map',
              latitude: -8.059941,
              longitude: -34.869800
            }
          end

          let(:expected_response) do
            {
              'places' => [
                { 'id' => marco_zero.id, 'latitude' => '-8.063105', 'longitude' => '-34.871084', 'name' => 'Marco Zero' },
                { 'id' => joana_bezerra.id, 'latitude' => '-8.073147', 'longitude' => '-34.895348', 'name' => 'Joana Bezerra' },
                { 'id' => camaragibe.id, 'latitude' => '-8.024639', 'longitude' => '-34.995402', 'name' => 'Camaragibe' }
              ],
              'total' => 3,
              'next_page' => nil
            }
          end

          it 'returns a success response' do
            get(:index, params: map_params)

            expect(response).to be_successful
            expect(parsed_response_body).to eq(expected_response)
          end
        end

        context 'with pagination' do
          before { (1..18).each { |n| create(:place, longitude: (n - 34.890048)) } }

          it 'returns places from page one' do
            get(:index)

            expect(response).to be_successful
            expect(parsed_response_body['places'].count).to eq(20)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(2)
          end

          it 'returns places from page two' do
            get(:index, params: { page: 2 })

            expect(response).to be_successful
            expect(parsed_response_body['places'].count).to eq(1)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(nil)
          end

          it 'returns places from page three' do
            get(:index, params: { page: 3 })

            expect(response).to be_successful
            expect(parsed_response_body['places'].count).to eq(0)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(nil)
          end
        end
      end
    end

    context 'when error' do
      context 'with invalid mode' do
        let(:map_params) do
          {
            mode: 'invalid',
            latitude: -8.059941,
            longitude: -34.869800
          }
        end

        it 'returns an error' do
          get(:index, params: map_params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq('{"error":"Invalid listing mode"}')
        end
      end

      context 'without latitude' do
        let(:map_params) do
          {
            mode: 'map',
            longitude: -34.869800
          }
        end

        it 'returns an error' do
          get(:index, params: map_params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq('{"error":"Latitude can\'t be blank"}')
        end
      end

      context 'without longitude' do
        let(:map_params) do
          {
            mode: 'map',
            latitude: -8.059941
          }
        end

        it 'returns an error' do
          get(:index, params: map_params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq('{"error":"Longitude can\'t be blank"}')
        end
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:place) }

    context 'with valid params' do
      it 'creates a new Place' do
        expect do
          post(:create, params: { place: valid_attributes })
        end.to change(Place, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(parsed_response_body['name']).to eq('Marco Zero')
        expect(parsed_response_body['latitude']).to eq('-8.063105')
        expect(parsed_response_body['longitude']).to eq('-34.871084')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { attributes_for(:place, latitude: nil) }

      let(:expected_error) { { 'errors' => { 'latitude' => ["can't be blank"] } } }

      it 'renders a JSON response with errors for the new place' do
        expect do
          post(:create, params: { place: invalid_attributes })

          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_response_body).to eq(expected_error)
        end.not_to change(Place, :count)
      end
    end

    context 'when place already exists' do
      let(:expected_error) { { 'errors' => { 'latitude' => ['has already been taken'] } } }

      before { create(:place) }

      it 'renders a JSON response with errors for the new place' do
        expect do
          post(:create, params: { place: valid_attributes })

          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_response_body).to eq(expected_error)
        end.not_to change(Place, :count)
      end
    end
  end
end
