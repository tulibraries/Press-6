Rails.application.routes.draw do
  namespace :admin do
    resources :books

    resource :books do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :books do
      member do
        post "detach" => :detach
      end
    end

      root to: "books#index"
    end
  resources :books
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
