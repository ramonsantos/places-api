# frozen_string_literal: true

module V1
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(_resource, _opts = {})
      render json: { token: jwt_token }, status: :created
    end

    def respond_to_on_destroy
      head :ok
    end

    def jwt_token
      "Bearer #{request.env['warden-jwt_auth.token']}"
    end
  end
end
