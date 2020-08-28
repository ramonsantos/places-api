# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
  get '/users', to: 'users#show'

  resources :places, only: [:create, :index]
end
