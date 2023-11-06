# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'static_pages#home'
end
