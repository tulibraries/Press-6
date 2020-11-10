# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :books
    resources :series
    resources :subjects
    # resources :catalogs
    resources :promotions

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

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
