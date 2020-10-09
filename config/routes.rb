Rails.application.routes.draw do
  namespace :admin do
    resources :books
    resources :series
    resources :subjects
    resources :catalogs

    resource :books, :series, :subjects do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books, :series, :subjects do
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

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
