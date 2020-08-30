# frozen_string_literal: true

require 'rails_helper'

describe V1::RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/users').to route_to('v1/registrations#create')
    end

    it 'routes to #update' do
      expect(put: '/users').to route_to('v1/registrations#update')
    end
  end
end
