# frozen_string_literal: true

module ActionCreate
  extend ActiveSupport::Concern

  private

  def create_resource(resource, success_body = nil)
    if resource.save
      render json: (success_body || resource), status: :created
    else
      render json: { errors: resource.errors.to_hash }, status: :unprocessable_entity
    end
  end
end
