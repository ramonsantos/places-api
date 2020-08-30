# frozen_string_literal: true

require 'rails_helper'

describe V1::SessionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:parsed_response_body) { JSON.parse(response.body) }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe '#create' do
    context 'when correct credentials' do
      it 'creates token' do
        post(:create, params: { user: attributes_for(:user) })

        expect(subject.current_user).to be_present
        expect(response).to have_http_status(:created)
        expect(parsed_response_body['token']).to match(/[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+$/)
      end
    end

    context 'when invalid credentials' do
      it 'does not create token' do
        post(:create, params: { user: { email: 'user123@gmail.com', password: 'as123456' } })

        expect(subject.current_user).to be_blank
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('{"error":"Invalid email or password."}')
      end
    end
  end

  describe '#destroy' do
    before { subject.sign_in(user) }

    it 'revokes token' do
      post(:destroy)

      expect(subject.current_user).to be_blank
      expect(response).to have_http_status(:ok)
      expect(response.body).to be_blank
    end
  end
end
