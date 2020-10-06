Rails.application.routes.draw do
  namespace :admin do
      resources :books

      root to: "books#index"
    end
  resources :books
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
