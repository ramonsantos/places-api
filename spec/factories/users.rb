# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'ramon.santos@gmail.com' }
    password { '123456' }
  end
end
