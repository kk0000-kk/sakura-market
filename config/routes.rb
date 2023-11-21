# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions', passwords: 'admins/passwords' }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admins do
    root 'static_pages#home'
    resources :admins, only: %i[index new create destroy]
    resources :users, only: %i[index destroy]
    resources :products, only: %i[index new create edit update destroy]
  end

  root 'static_pages#index'
  resources :products, only: %i[index show]
  resource :cart, only: :show
end
