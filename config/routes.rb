# frozen_string_literal: true

Rails.application.routes.draw do
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

  resources :books
  resources :series
  resources :subjects
  resources :catalogs
  resources :agencies
  resources :webpages
  resources :special_offers

  root to: "webpages#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
