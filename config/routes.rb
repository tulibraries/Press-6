# frozen_string_literal: true

Rails.application.routes.draw do

  concern :imageable do
    get "image/thumbnail", to: "images#thumbnail_image"
    get "image/medium",    to: "images#medium_image"
    get "image/large",     to: "images#large_image"
  end

  namespace :admin do
    resources :agencies
    resources :books
    resources :brochures
    resources :catalogs
    resources :journals
    resources :series
    resources :special_offers
    resources :subjects
    resources :webpages

    resource :books, :brochures, :series, :subjects, :special_offers do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :brochures, :series, :subjects, :special_offers do
      member do
        post "detach" => :detach
      end
    end

    root to: "books#index"
  end

  resources :books, concerns: [:imageable]
  resources :series, concerns: [:imageable]
  resources :subjects, concerns: [:imageable]
  resources :catalogs
  resources :agencies
  resources :webpages
  resources :brochures, only: [:show], concerns: [:imageable]
  resources :special_offers, concerns: [:imageable]

  root to: "webpages#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
