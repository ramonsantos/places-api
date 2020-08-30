# frozen_string_literal: true

require 'rails_helper'

describe V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/users').to route_to('v1/users#show')
    end
  end
end
