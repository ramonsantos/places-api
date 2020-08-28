# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/users').to route_to('users#show')
    end
  end
end
