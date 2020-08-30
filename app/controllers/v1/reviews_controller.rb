# frozen_string_literal: true

module V1
  class ReviewsController < ApplicationController
    include ActionCreate
    include Pagination

    before_action :authenticate_user!

    # GET /places/:place_id/reviews
    def index
      if place.present?
        render json: serialized_reviews
      else
        render json: { error: 'Place not found' }, status: :not_found
      end
    end

    # POST /places/:place_id/reviews
    def create
      create_resource(build_new_review)
    end

    private

    def review_params
      params.require(:review).permit(:rating, :comment, :place_id)
    end

    def build_new_review
      Review.new(review_params.merge!(place_id: params[:place_id]))
    end

    def reviews
      Review.by_place(place).page(page)
    end

    def place
      @place ||= fetch_place
    end

    def fetch_place
      Place.find(params[:place_id])
    rescue StandardError
      nil
    end

    def serialized_reviews
      {
        reviews: reviews,
        place: serialized_place,
        total: Review.by_place(place).count,
        next_page: reviews.next_page
      }
    end

    def serialized_place
      {
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
        average_rating: Review.by_place(place).average(:rating).try(:round, 1)
      }
    end
  end
end
