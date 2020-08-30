# frozen_string_literal: true

Rails.application.routes.draw do
  api_version(module: 'V1', default: true, header: { name: 'X-Version', value: 'version=1' }) do
    devise_for :users, controllers: { sessions: 'v1/sessions', registrations: 'v1/registrations' }, skip: [:registrations, :sessions]
    devise_scope :user do
      post   '/users',          to: 'registrations#create'
      put    '/users',          to: 'registrations#update'
      post   '/users/sign_in',  to: 'sessions#create'
      delete '/users/sign_out', to: 'sessions#destroy'
    end

    get '/users', to: 'users#show'

    resources :places, only: [:create, :index] do
      resources :reviews, only: [:create, :index]
    end
  end
end
