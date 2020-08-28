# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { user: current_user }, status: :ok
  end
end
