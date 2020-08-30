# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: { user: current_user }, status: :ok
    end
  end
end
