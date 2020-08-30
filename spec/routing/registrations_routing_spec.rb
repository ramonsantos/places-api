# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/users').to route_to('registrations#create')
    end

    it 'routes to #update' do
      expect(put: '/users').to route_to('registrations#update')
    end
  end
end
