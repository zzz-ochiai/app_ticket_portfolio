Rails.application.routes.draw do
  get "tickets/index"

  devise_for :users
  devise_for :admins, controllers: {
    registrations: "admins/registrations"
  }

  namespace :admin do
    root "dashboard#index"

    resources :users, only: [:index, :show] do
      resources :tickets, only: [:create] 
    end

    resources :tickets, only: [:destroy] do
      member do
        patch :revert
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "tickets#index"
  # トップページのルーティング

  resources :tickets, only: [:index, :update]
  
  namespace :old_admin do
    resources :users, only: [:index, :show]
    resources :tickets, only: [] do
      member do
        patch :revert
      end
      # resourcesを使ってTicketリソースを１つのまとまりにすることで、コードの可読性を上げている。
      # memberを使うことで特定のチケットに対してアクションを定義できる。
    end
  end
  
end
