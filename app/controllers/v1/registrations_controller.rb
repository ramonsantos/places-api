# frozen_string_literal: true

module V1
  class RegistrationsController < Devise::RegistrationsController
    include ActionCreate

    respond_to :json

    # POST /users
    def create
      create_resource(build_resource(sign_up_params), '')
    end

    # PUT /users
    def update
      super
    end
  end
end
