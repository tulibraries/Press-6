# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

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
    resources :faqs
    resources :highlights
    resources :journals
    resources :news_items
    resources :oabooks
    resources :people
    resources :series
    resources :special_offers
    resources :subjects
    resources :webpages

    resource :books, :brochures, :catalogs, :documents, :events, :highlights, :news_items, :oabooks, :people, :series,
             :subjects, :special_offers do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :brochures, :catalogs, :documents, :events, :highlights, :news_items, :oabooks, :people, :series,
             :subjects, :special_offers do
      member do
        post "detach" => :detach
      end
    end

    root to: "books#index"
  end

  resources :agencies, only: [:index]
  resources :authors, only: %i[index show]
  resources :books, concerns: [:imageable]
  resources :catalogs, concerns: [:imageable]
  resources :conferences, only: [:index]
  resources :documents, only: [:index]
  resources :events, only: [:index]
  resources :faqs, only: %i[index show]
  resources :forms, only: %i[new create]
  resources :news_items, only: [:show], concerns: [:imageable]
  resources :highlights, only: [:show], concerns: [:imageable]
  resources :oabooks, only: [:show], concerns: [:imageable]
  resources :people, only: %i[index sales_reps], concerns: [:imageable]
  resources :series, only: %i[index show], concerns: [:imageable]
  resources :special_offers, concerns: [:imageable]
  resources :subjects, only: %i[index show]
  resources :webpages, only: %i[index show]

  root to: "webpages#index"

  get "search"                => "webpages#search", as: :search
  get "downloads"             => "documents#index", as: :downloads
  get "sales-reps"            => "people#sales_reps", as: :sales_reps
  get "course-adoptions"      => "books#course_adoptions", as: :course_adoptions
  get "study-guides"          => "books#study_guides", as: :study_guides
  get "study-guides/:id"      => "books#study_guide", as: :study_guide

  get "awards" => "books#awards", as: :awards
  get "awards/subject/:id"    => "books#awards_by_subject", as: :awards_by_subject
  get "awards/year/:id"       => "books#awards_by_year", as: :awards_by_year

  get "/open-access/north-broad-press"      => "oabooks#north_broad_press", as: :north_broad
  get "/open-access/labor-studies"          => "oabooks#labor_studies", as: :labor_studies
  get "/open-access/labor-studies/:id"      => "oabooks#show", as: :labor_studies_book
  get "/open-access/north-broad-press/:id"  => "oabooks#show", as: :north_broad_book

  get "forms", to: "forms#index", as: "forms_index"
  get "forms/*type", to: "forms#new", as: "form"

  get "promotions", to: "special_offers#index"
  get "promotions/:id", to: "special_offers#index"

  get "book/:id", to: "books#show", as: "book_redirect"
end
