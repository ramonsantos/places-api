# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

describe V1::UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #show' do
    context 'when success' do
      before do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        request.headers.merge!(Devise::JWT::TestHelpers.auth_headers(headers, user))
      end

      it 'returns user profile' do
        get(:show)

        expect(response).to be_successful
        expect(response.body).to eq('{"user":{"email":"ramon.santos@gmail.com"}}')
      end
    end

    context 'when unauthenticated user' do
      it 'returns user profile' do
        get(:show)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('{"error":"You need to sign in or sign up before continuing."}')
      end
    end
  end
end
