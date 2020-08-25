# frozen_string_literal: true

Rails.application.routes.draw do
  resources :places, only: [:create, :index]
end
