# frozen_string_literal: true

require 'rails_helper'

describe V1::PlacesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/places').to route_to('v1/places#index')
    end

    it 'routes to #create' do
      expect(post: '/places').to route_to('v1/places#create')
    end
  end
end
