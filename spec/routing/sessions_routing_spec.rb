# frozen_string_literal: true

require 'rails_helper'

describe V1::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(post: '/users/sign_in').to route_to('v1/sessions#create')
    end

    it 'routes to #create' do
      expect(delete: '/users/sign_out').to route_to('v1/sessions#destroy')
    end
  end
end
