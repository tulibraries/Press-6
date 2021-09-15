# frozen_string_literal: true

Rails.application.routes.draw do

  resources :events
  devise_for :users
  concern :imageable do
    get "image/thumbnail", to: "images#thumbnail_image"
    get "image/medium",    to: "images#medium_image"
    get "image/large",     to: "images#large_image"
  end

  namespace :admin do
    resources :agencies
    resources :authors
    resources :books
    resources :brochures
    resources :catalogs
    resources :conferences
    resources :documents
    resources :events
    resources :highlights
    resources :journals
    resources :oabooks
    resources :people
    resources :series
    resources :special_offers
    resources :subjects
    resources :webpages

    resource :books, :brochures, :catalogs, :documents, :highlights, :oabooks, :people, :series, :subjects, :special_offers do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :brochures, :catalogs, :documents, :highlights, :oabooks, :people, :series, :subjects, :special_offers do
      member do
        post "detach" => :detach
      end
    end

    root to: "books#index"
  end

  resources :agencies, only: [:index]
  resources :authors, only: [:index, :show]
  resources :books, concerns: [:imageable]
  resources :catalogs, concerns: [:imageable]
  resources :conferences, only: [:index]
  resources :documents, only: [:index]
  resources :events, only: [:index]
  resources :highlights, only: [:show], concerns: [:imageable]
  resources :oabooks, only: [:show], concerns: [:imageable]
  resources :people, only: [:index, :sales_reps], concerns: [:imageable]
  resources :series, only: [:index, :show], concerns: [:imageable]
  resources :special_offers, concerns: [:imageable]
  resources :subjects, only: [:index, :show]
  resources :webpages, only: [:index, :show]

  root to: "webpages#index"

  get "downloads"             => "documents#index"

  get "sales-reps"            => "people#sales_reps", as: :sales_reps

  get "course-adoptions"      => "books#course_adoptions", as: :course_adoptions

  get "study-guides"          => "books#study_guides", as: :study_guides
  get "study-guides/:id"      => "books#study_guides", as: :study_guide

  get "awards"				        => "books#awards", as: :awards
  get "awards/subject/:id"    => "books#awards_by_subject", as: :awards_by_subject
  get "awards/year/:id"       => "books#awards_by_year", as: :awards_by_year

  get "/open-access/north-broad-press"      => "oabooks#north_broad_press", as: :north_broad
  get "/open-access/labor-studies"          => "oabooks#labor_studies", as: :labor_studies
  get "/open-access/labor-studies/:id"      => "oabooks#show", as: :labor_studies_book
  get "/open-access/north-broad-press/:id"  => "oabooks#show", as: :north_broad_book

end
