# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let(:valid_attributes) { attributes_for(:place) }
  let(:invalid_attributes) { attributes_for(:place, latitude: nil) }
  let(:parsed_response_body) { JSON.parse(response.body) }

  describe 'GET #index' do
    context "when there aren't places" do
      it 'returns a success response' do
        get(:index)

        expect(response).to be_successful
        expect(parsed_response_body).to eq({ 'places' => [] })
      end
    end

    context 'when there are places' do
      let!(:recife) { create(:place) }

      let(:expected_response) do
        {
          'places' => [
            { 'id' => recife.id, 'latitude' => '-8.050004', 'longitude' => '-34.900002', 'name' => 'Recife' }
          ]
        }
      end

      it 'returns a success response' do
        get(:index)

        expect(response).to be_successful
        expect(parsed_response_body).to eq(expected_response)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Place' do
        expect do
          post(:create, params: { place: valid_attributes })
        end.to change(Place, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(parsed_response_body['name']).to eq('Recife')
        expect(parsed_response_body['latitude']).to eq('-8.050004')
        expect(parsed_response_body['longitude']).to eq('-34.900002')
      end
    end

    context 'with invalid params' do
      let(:expected_error) { { 'errors' => { 'latitude' => ["can't be blank"] } } }

      it 'renders a JSON response with errors for the new place' do
        post(:create, params: { place: invalid_attributes })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response_body).to eq(expected_error)
      end
    end
  end
end
