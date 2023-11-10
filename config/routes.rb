# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions', passwords: 'admins/passwords' }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admins do
    root 'static_pages#home'
    resources :admins
  end

  root 'static_pages#index'
  get 'home', to: 'static_pages#home'
end
