# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    user { User.first || create(:user) }

    name { 'Marco Zero' }
    latitude { -8.063105 }
    longitude { -34.871084 }

    trait :place_joana_bezerra do
      name { 'Joana Bezerra' }
      latitude { -8.073147 }
      longitude { -34.895348 }
    end

    trait :place_camaragibe do
      name { 'Camaragibe' }
      latitude { -8.024639 }
      longitude { -34.995402 }
    end

    factory :place_joana_bezerra, traits: [:place_joana_bezerra]
    factory :place_camaragibe, traits: [:place_camaragibe]
  end
end
