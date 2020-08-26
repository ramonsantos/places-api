# frozen_string_literal: true

class PlacesController < ApplicationController
  # GET /places
  def index
    @places = Place.all

    render json: { places: @places }
  end

  # POST /places
  def create
    @place = Place.new(place_params)

    if @place.save
      render json: @place, status: :created
    else
      render json: { errors: @place.errors.to_hash }, status: :unprocessable_entity
    end
  end

  private

  def place_params
    params.require(:place).permit(:name, :latitude, :longitude)
  end
end