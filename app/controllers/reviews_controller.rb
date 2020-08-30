# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!

  # GET /places/:place_id/reviews
  def index
    if place.blank?
      render json: { error: 'Place not found' }, status: :not_found
    else
      render json: serialized_reviews
    end
  end

  # POST /places/:place_id/reviews
  def create
    @review = Review.new(review_params.merge!(place_id: params[:place_id]))

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment, :place_id)
  end

  def page
    params[:page] || 1
  end

  def reviews
    @reviews ||= Review.where(place: place).page(page)
  end

  def place
    @place ||= fetch_place
  end

  def fetch_place
    Place.find(params[:place_id])
  rescue StandardError
    nil
  end

  def serialized_place
    {
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude,
      average_rating: Review.where(place: place).average(:rating).try(:round, 1)
    }
  end

  def serialized_reviews
    {
      reviews: reviews,
      place: serialized_place,
      total: Review.where(place: place).count,
      next_page: reviews.next_page
    }
  end
end
