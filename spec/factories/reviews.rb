# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    place { Place.first || create(:place) }

    rating { 3 }
    comment { '' }
  end
end
