# frozen_string_literal: true

module V1
  class PlacesController < ApplicationController
    include ActionCreate
    include Pagination

    before_action :authenticate_user!

    rescue_from StandardError, with: :render_error

    # GET /places
    def index
      raise(StandardError, 'Invalid listing mode') if invalid_listing_mode?

      render json: { places: places, total: Place.count, next_page: places.next_page }
    end

    # POST /places
    def create
      create_resource(build_new_place)
    end

    private

    def render_error(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    def place_params
      params.require(:place).permit(:name, :latitude, :longitude)
    end

    def build_new_place
      Place.new(place_params.merge!(user: current_user))
    end

    def listing_mode
      @listing_mode ||= params[:mode].try(:to_sym) || :list
    end

    def invalid_listing_mode?
      [:list, :map].exclude?(listing_mode)
    end

    def places
      return Place.all.order(:name).page(page) if listing_mode == :list

      Place.closest(origin: origin_coordinates).page(page)
    end

    def origin_coordinates
      [present_parameter(:latitude), present_parameter(:longitude)]
    end

    def present_parameter(parameter)
      return params[parameter] if params[parameter].present?

      raise(StandardError, "#{parameter.capitalize} can't be blank")
    end
  end
end
