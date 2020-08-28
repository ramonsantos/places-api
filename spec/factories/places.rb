# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    user { User.first || create(:user) }

    name { 'Recife' }
    latitude { -8.0500043 }
    longitude { -34.9000023 }
  end
end
