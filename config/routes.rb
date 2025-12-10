Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Employee routes
  resources :employees do
    member do
      get :attendance
    end
  end

  resources :tasks, only: [:index]
  resources :task_filters, only: [:create, :destroy]
  resources :holidays, only: [:index, :create, :destroy]
  
  get "access_control", to: "access_control#index", as: :access_control
  post "access_control/search", to: "access_control#search"
  patch "access_control/update_permissions", to: "access_control#update_permissions"
  
  resources :od_requests, only: [:index, :create] do
    member do
      patch :cancel
    end
  end
  resources :leave_requests, only: [:index, :create] do
    member do
      patch :cancel
    end
  end
  
  resources :approve_requests, only: [:index] do
    member do
      patch :update_od_status
      patch :update_leave_status
    end
  end

  resources :projects do
    member do
      get :details
    end
    resources :project_employees, only: [:create, :destroy]
    resources :tasks, only: [:new, :create, :edit, :update, :destroy]
  end

  # Root route
  root "dashboard#index"

  # Health + PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
