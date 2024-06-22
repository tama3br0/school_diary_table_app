Rails.application.routes.draw do
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

    authenticated :user do
      root to: 'pages#login_success', as: :authenticated_root
    end

    unauthenticated do
      root to: 'home#index', as: :unauthenticated_root
    end

    get 'pages/login_success', to: 'pages#login_success', as: 'login_success'
    get 'pages/login_failure', to: 'pages#login_failure', as: 'login_failure'

    get 'users/additional_info', to: 'users#additional_info', as: 'additional_info'
    patch 'users/save_additional_info', to: 'users#save_additional_info', as: 'save_additional_info'

    # Diaries routes
    resources :diaries, only: [:new, :create, :index, :show]
end
