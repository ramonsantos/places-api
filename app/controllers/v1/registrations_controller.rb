# frozen_string_literal: true

module V1
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      if resource.save
        render nothing: true, status: :created
      else
        render json: { errors: resource.errors.to_hash }, status: :unprocessable_entity
      end
    end
  end
end
