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
    resources :conferences
    resources :journals
    resources :oabooks
    resources :people
    resources :series
    resources :special_offers
    resources :subjects
    resources :webpages

    resource :books, :brochures, :oabooks, :people, :series, :subjects, :special_offers do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :brochures, :oabooks, :people, :series, :subjects, :special_offers do
      member do
        post "detach" => :detach
      end
    end

    root to: "books#index"
  end

  resources :agencies, only: [:index]
  resources :books, concerns: [:imageable]
  resources :catalogs
  resources :conferences, only: [:index]
  resources :people, only: [:index], concerns: [:imageable]
  resources :series, concerns: [:imageable]
  resources :special_offers, concerns: [:imageable]
  resources :subjects, concerns: [:imageable]
  resources :webpages, only: [:show]

  root to: "webpages#index"

  controller :oabooks do
    get 'open-access/labor-studies'                => :labor_studies, as: "labor_studies"
    get 'open-access/north-broad-press'            => :north_broad_press, as: "north_broad"
    get 'open-access/labor-studies/:id'            => :show, as: "labor_studies_book"
    get 'open-access/labor-studies/:id/epub'       => :download_epub
    get 'open-access/labor-studies/:id/pdf'        => :download_pdf
    get 'open-access/labor-studies/:id/mobi'       => :download_mobi
    get 'open-access/north-broad-press/:id'        => :show, as: "north_broad_book"
    get 'open-access/north-broad-press/:id/epub'   => :download_epub
    get 'open-access/north-broad-press/:id/pdf'    => :download_pdf
    get 'open-access/north-broad-press/:id/mobi'   => :download_mobi
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
