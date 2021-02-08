# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :agencies
    resources :books
    resources :brochures
    resources :catalogs
    resources :promotions
    resources :series
    resources :subjects
    resources :webpages

    resource :books, :brochures, :series, :subjects, :promotions do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :brochures, :series, :subjects, :promotions do
      member do
        post "detach" => :detach
      end
    end

    root to: "books#index"
  end

  resources :books
  resources :series
  resources :subjects
  resources :catalogs
  resources :promotions
  resources :agencies
  resources :webpages

  root to: "books#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
