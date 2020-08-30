# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

describe V1::ReviewsController, type: :controller do
  let(:invalid_attributes) { attributes_for(:review, rating: nil) }
  let(:parsed_response_body) { JSON.parse(response.body) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user, email: 'veronica.silva@gmail.com') }
  let(:place) { create(:place_camaragibe, user: user2) }

  before do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    request.headers.merge!(Devise::JWT::TestHelpers.auth_headers(headers, user1))
  end

  describe 'GET #index' do
    before { create(:review, place_id: create(:place_joana_bezerra, user: user1).id) }

    context 'when success' do
      context "when there aren't reviews" do
        let(:expected_response) do
          {
            'reviews' => [],
            'place' => {
              'average_rating' => nil, 'latitude' => '-8.024639', 'longitude' => '-34.995402', 'name' => 'Camaragibe'
            },
            'total' => 0,
            'next_page' => nil
          }
        end

        it 'returns a success response' do
          get(:index, params: { place_id: place.id })

          expect(response).to be_successful
          expect(parsed_response_body).to eq(expected_response)
        end
      end

      context 'when there are places' do
        let!(:review1) { create(:review, place_id: place.id, rating: 5, comment: 'Amazing') }
        let!(:review2) { create(:review, place_id: place.id, rating: 4) }

        let(:expected_response) do
          {
            'next_page' => nil,
            'place' => {
              'average_rating' => '4.5',
              'latitude' => '-8.024639',
              'longitude' => '-34.995402',
              'name' => 'Camaragibe'
            },
            'reviews' => [
              { 'comment' => 'Amazing', 'id' => review1.id, 'rating' => 5 },
              { 'comment' => '',        'id' => review2.id, 'rating' => 4 }
            ],
            'total' => 2
          }
        end

        it 'returns place reviews' do
          get(:index, params: { place_id: place.id })

          expect(response).to be_successful
          expect(parsed_response_body).to eq(expected_response)
        end

        context 'with pagination' do
          before { create_list(:review, 19, place_id: place.id) }

          let(:expected_place) do
            {
              'average_rating' => '3.1',
              'latitude' => '-8.024639',
              'longitude' => '-34.995402',
              'name' => 'Camaragibe'
            }
          end

          it 'returns reviews from page one' do
            get(:index, params: { place_id: place.id })

            expect(response).to be_successful
            expect(parsed_response_body['reviews'].count).to eq(20)
            expect(parsed_response_body['place']).to eq(expected_place)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(2)
          end

          it 'returns reviews from page two' do
            get(:index, params: { place_id: place.id, page: 2 })

            expect(response).to be_successful
            expect(parsed_response_body['reviews'].count).to eq(1)
            expect(parsed_response_body['place']).to eq(expected_place)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(nil)
          end

          it 'returns reviews from page three' do
            get(:index, params: { place_id: place.id, page: 3 })

            expect(response).to be_successful
            expect(parsed_response_body['reviews'].count).to eq(0)
            expect(parsed_response_body['place']).to eq(expected_place)
            expect(parsed_response_body['total']).to eq(21)
            expect(parsed_response_body['next_page']).to eq(nil)
          end
        end
      end
    end

    context 'when error' do
      it 'returns a error response' do
        get(:index, params: { place_id: 0 })

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('{"error":"Place not found"}')
      end
    end
  end

  describe 'POST #create' do
    context 'when success' do
      let(:valid_params) { { review: { rating: 3, comment: '' }, place_id: place.id } }

      it 'creates a new Review' do
        expect do
          post(:create, params: valid_params)

          expect(response).to have_http_status(:created)
          expect(parsed_response_body['rating']).to eq(3)
          expect(parsed_response_body['comment']).to be_blank
        end.to change(Review, :count).by(1)
      end
    end

    context 'when error' do
      context 'when the user tries create review without rating' do
        let(:invalid_params) { { review: { comment: '' }, place_id: place.id } }

        let(:expected_error) { '{"rating":["can\'t be blank","is not included between 1 and 5"]}' }

        it 'renders a JSON response with errors for the new Review' do
          expect do
            post(:create, params: invalid_params)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq(expected_error)
          end.not_to change(Review, :count)
        end
      end

      context 'when the user tries create review with invalid rating' do
        let(:invalid_params) { { review: { rating: 6, comment: '' }, place_id: place.id } }

        it 'renders a JSON response with errors for the new Review' do
          expect do
            post(:create, params: invalid_params)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq('{"rating":["is not included between 1 and 5"]}')
          end.not_to change(Review, :count)
        end
      end

      context 'when the user tries create review without place' do
        let(:invalid_params) { { review: { rating: 3, comment: '' }, place_id: 0 } }

        it 'renders a JSON response with errors for the new Review' do
          expect do
            post(:create, params: invalid_params)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq('{"place":["must exist"]}')
          end.not_to change(Review, :count)
        end
      end
    end
  end
end
