# frozen_string_literal: true

Rails.application.routes.draw do
  resources :webpages
  namespace :admin do
    resources :books
    resources :series
    resources :subjects
    resources :catalogs, only: [:index, :show]
    resources :promotions
    resources :webpages

    resource :books, :series, :subjects, :promotions do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :series, :subjects, :promotions do
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

  root to: "books#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
