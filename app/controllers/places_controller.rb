# frozen_string_literal: true

class PlacesController < ApplicationController
  before_action :authenticate_user!

  rescue_from StandardError, with: :render_error

  # GET /places
  def index
    raise(StandardError, 'Invalid listing mode') if invalid_listing_mode?

    render json: { places: places, total: Place.count, next_page: places.next_page }
  end

  # POST /places
  def create
    @place = Place.new(place_params.merge!(user: current_user))

    if @place.save
      render json: @place, status: :created
    else
      render json: { errors: @place.errors.to_hash }, status: :unprocessable_entity
    end
  end

  private

  def render_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def place_params
    params.require(:place).permit(:name, :latitude, :longitude)
  end

  def page
    params[:page] || 1
  end

  def listing_mode
    @listing_mode ||= params[:mode].try(:to_sym) || :list
  end

  def invalid_listing_mode?
    [:list, :map].exclude?(listing_mode)
  end

  def places
    return Place.all.order(:name).page(page) if listing_mode == :list

    Place.closest(origin: [latitude, longitude]).page(page)
  end

  def latitude
    raise(StandardError, "Latitude can't be blank") if params[:latitude].blank?

    params[:latitude]
  end

  def longitude
    raise(StandardError, "Longitude can't be blank") if params[:longitude].blank?

    params[:longitude]
  end
end
