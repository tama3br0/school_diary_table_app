Rails.application.routes.draw do

    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

    get 'pages/login_success',    to: 'pages#login_success',    as: 'login_success'
    get 'pages/login_failure',    to: 'pages#login_failure',    as: 'login_failure'
end
