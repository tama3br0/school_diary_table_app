Rails.application.routes.draw do
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

    authenticated :user do
      root to: 'pages#login_success', as: :authenticated_root
    end

    unauthenticated do
      root to: 'home#index', as: :unauthenticated_root
    end

    devise_scope :user do
        get '/users/sign_out' => 'devise/sessions#destroy'
    end

    get 'pages/login_success', to: 'pages#login_success', as: 'login_success'
    get 'pages/login_failure', to: 'pages#login_failure', as: 'login_failure'

    get 'users/additional_info',        to: 'users#additional_info',      as: 'additional_info'
    patch 'users/save_additional_info', to: 'users#save_additional_info', as: 'save_additional_info'

    # Diaries routes
    resources :diaries, only: [:new, :create, :index, :show]

    authenticate :user, lambda { |u| u.teacher? } do
        get 'class_selection',   to: 'diaries#class_selection', as: 'class_selection'
        get 'class_diary/:id',   to: 'diaries#class_diary',     as: 'class_diary'
        get 'student_diary/:id', to: 'diaries#student_diary',   as: 'student_diary'

        get 'teacher/select_class',          to: 'teachers#select_class',   as: :select_class
        get 'teacher/student_list/:id',      to: 'teachers#student_list',   as: :student_list
        delete 'teacher/remove_student/:id', to: 'teachers#remove_student', as: :remove_student
    end
end
