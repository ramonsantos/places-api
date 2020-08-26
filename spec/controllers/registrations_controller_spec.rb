# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  let(:valid_attributes) { { user: attributes_for(:user) } }

  describe '#create' do
    context 'when success' do
      it 'creates user' do
        expect do
          post(:create, params: valid_attributes)

          expect(response).to have_http_status(:created)
          expect(response.body).to be_blank
        end.to change(User, :count).by(1)
      end
    end

    context 'when error' do
      context 'when email error' do
        context 'when invalid email' do
          let(:invalid_attributes) { { user: { email: 'user', password: 'as123456' } } }

          it 'does not create user' do
            expect do
              post(:create, params: invalid_attributes)

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to eq('{"errors":{"email":["is invalid"]}}')
            end.not_to change(User, :count)
          end
        end

        context 'when blank email' do
          let(:invalid_attributes) { { user: { password: 'as123456' } } }

          it 'does not create user' do
            expect do
              post(:create, params: invalid_attributes)

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to eq('{"errors":{"email":["can\'t be blank"]}}')
            end.not_to change(User, :count)
          end
        end
      end

      context 'when password error' do
        context 'when invalid password' do
          let(:invalid_attributes) { { user: { email: 'user.user@gmail.com', password: '12345' } } }

          it 'does not create user' do
            expect do
              post(:create, params: invalid_attributes)

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to eq('{"errors":{"password":["is too short (minimum is 6 characters)"]}}')
            end.not_to change(User, :count)
          end
        end

        context 'when blank password' do
          let(:invalid_attributes) { { user: { email: 'user.user@gmail.com' } } }

          it 'does not create user' do
            expect do
              post(:create, params: invalid_attributes)

              expect(response).to have_http_status(:unprocessable_entity)
              expect(response.body).to eq('{"errors":{"password":["can\'t be blank"]}}')
            end.not_to change(User, :count)
          end
        end
      end

      context 'when user already exists' do
        before { create(:user) }

        it 'does not create user' do
          expect do
            post(:create, params: valid_attributes)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq('{"errors":{"email":["has already been taken"]}}')
          end.not_to change(User, :count)
        end
      end
    end
  end
end
