Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  #ユーザー用ルーティング
  resources :tickets, only: [:index, :update]
  root "tickets#index"

  #管理者用ルーティング
  namespace :admin do
    root "dashboard#index"

    resources :users, only: [:index, :show] do
      resources :tickets, only: [:create] 
    end

    resources :tickets, only: [:destroy] do
      member do
        patch :revert
        patch :mark_used
      end
    end
  end

  #ヘルスチェック用ルーティング
  get "up" => "rails/health#show", as: :rails_health_check
end

# ＜学習メモ＞
# device_forでは認証スコープ（認証先を区別するための対象）の設定をしている