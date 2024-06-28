Rails.application.routes.draw do
    # usersというリソース全体に対しての設定のため、複数形
    # ユーザー全体に対する操作や、ユーザーの集合に対するアクションを
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

    # 特定のユーザーに対する操作のため、単数形
    authenticated :user do
        root to: 'pages#login_success', as: 'authenticated_root'
    end

    unauthenticated do
        root to: 'home#index', as: 'unauthenticated_root'
    end

    devise_scope :user do
        get '/users/sign_out' => 'devise/sessions#destroy' # link_toでログアウトが発動するように
    end

    get 'pages/login_success', to: 'pages#login_success', as: 'login_success'
    get 'pages/login_failure', to: 'pages#login_failure', as: 'login_failure'

    get 'users/additional_info',        to: 'users#additional_info',      as: 'additional_info'
    patch 'users/save_additional_info', to: 'users#save_additional_info', as: 'save_additional_info'

    # 日記リソースの集合全体を設定したいので複数形。この設定により、複数の日記に対するアクションが可能
    resources :diaries, only: [:new, :create, :index, :show] do
        collection do
            get  'new_for_student/:student_id',     to: 'diaries#new_for_student',      as: 'new_for_student'
            post 'create_for_student/:student_id',  to: 'diaries#create_for_student',   as: 'create_for_student'
        end
    end

    authenticate :user, lambda { |u| u.teacher? } do
        get 'class_selection',   to: 'diaries#class_selection', as: 'class_selection'
        get 'class_diary/:id',   to: 'diaries#class_diary',     as: 'class_diary'
        get 'student_diary/:id', to: 'diaries#student_diary',   as: 'student_diary'


        get 'teacher/select_class',          to: 'teachers#select_class',   as: 'select_class'
        get 'teacher/student_list/:id',      to: 'teachers#student_list',   as: 'student_list'
        delete 'teacher/remove_student/:id', to: 'teachers#remove_student', as: 'remove_student'

        # グラフ化
        # get 'student_diary_graph/:id',          to: 'teachers#student_diary_graph',   as: 'student_diary_graph'
        get 'teacher/select_class_graphs',      to: 'teachers#select_class_graphs',   as: 'select_class_graphs'
        get 'teacher/emotion_distribution/:id', to: 'teachers#emotion_distribution',  as: 'emotion_distribution'
    end
end
