
Rails.application.routes.draw do
  resources :users, only: [ :new, :create ]
  resources :places, only: [ :index, :show, :new, :create ]
  resources :session, only: [ :new, :create, :destroy ]
  resources :check_ins, only: [ :new, :create, :show ]

  namespace :admin do
    get "users/index"
    get "users/show"
    get "users/promote"
    get "users/demote"
    get "users/lock"
    get "users/unlock"
  end
  namespace :moderation do
    get "status_reports/show"
    get "status_reports/approve"
    get "status_reports/reject"
    get "places/show"
    get "places/edit"
    get "places/update"
    get "places/approve"
    get "places/reject"
    get "places/unlock"
    get "dashboards/show"
  end
  get "profile/show"
  get "profile/edit"
  get "profile/update"
  get "status_reports/new"
  get "status_reports/create"
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
