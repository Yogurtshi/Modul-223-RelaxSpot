
Rails.application.routes.draw do
  resources :users, only: [ :new, :create ]
  resources :places, only: [ :index, :show, :new, :create ]
  resource :session, only: [ :new, :create, :destroy ]
  resources :check_ins, only: [ :new, :create, :show ]

  namespace :admin do
    resources :users, only: [ :index, :show ] do
      member do
        post :promote
        post :demote
        post :lock
        post :unlock
      end
    end
  end
  namespace :moderation do
    resources :status_reports, only: [ :show ] do
      member do
        post :approve
        post :reject
      end
    end

    resources :places, only: [ :show, :edit, :update ] do
      member do
        post :approve
        post :reject
        post :unlock
      end
    end

    get "dashboards/show"
  end
  get "profile/show"
  get "profile/edit"
  get "profile/update"
  resources :status_reports, only: [ :new, :create ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
