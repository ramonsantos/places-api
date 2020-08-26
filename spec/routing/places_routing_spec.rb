# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlacesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/places').to route_to('places#index')
    end

    it 'routes to #create' do
      expect(post: '/places').to route_to('places#create')
    end
  end
end