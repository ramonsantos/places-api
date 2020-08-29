# frozen_string_literal: true

require 'rails_helper'

describe ReviewsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/places/1/reviews').to route_to('reviews#index', place_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/places/1/reviews').to route_to('reviews#create', place_id: '1')
    end
  end
end
