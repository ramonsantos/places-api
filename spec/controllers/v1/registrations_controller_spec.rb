# frozen_string_literal: true

require 'rails_helper'

describe V1::RegistrationsController, type: :controller do
  let!(:user) { create(:user, email: 'veronica.ferreira@gmail.com') }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#create' do
    let(:valid_attributes) { { user: attributes_for(:user) } }

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

  describe '#update' do
    let(:new_email) { 'veronica.silva@gmail.com' }

    before { headers_authorization(user) }

    context 'when success' do
      context 'when update user email' do
        it 'updates user' do
          expect do
            patch(:update, params: { user: { email: new_email, current_password: user.password } })

            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
            user.reload
          end.to change(user, :email)
        end
      end

      context 'when update user password' do
        it 'updates user' do
          expect do
            patch(:update, params: { user: { current_password: user.password, password: 'abc123' } })

            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
            user.reload
          end.to change(user, :encrypted_password)
        end
      end

      context 'when update email and password' do
        let(:params) do
          { user: { current_password: user.password, password: 'abc123', email: new_email } }
        end

        it 'updates user' do
          expect do
            put(:update, params: params)

            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
            user.reload
            expect(user.email).to eq(new_email)
          end.to change(user, :encrypted_password)
        end
      end
    end

    context 'when error' do
      context 'when tries to update without "current_password"' do
        let(:params) { { user: { password: 'abc123', email: new_email } } }
        let(:expected_error) { '{"errors":{"current_password":["can\'t be blank"]}}' }

        it 'return error' do
          put(:update, params: params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(expected_error)
        end
      end
    end
  end
end
