# frozen_string_literal: true

require 'rails_helper'

describe V1::UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #show' do
    context 'when success' do
      before { headers_authorization(user) }

      it 'returns user profile' do
        get(:show)

        expect(response).to be_successful
        expect(response.body).to eq('{"user":{"email":"syd.barrett@gmail.com"}}')
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
