Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  # Password Reset routes
  get "forgot_password", to: "password_reset#forgot_password", as: :forgot_password
  post "send_code", to: "password_reset#send_code", as: :send_code
  get "verify_code", to: "password_reset#verify_code", as: :verify_code
  post "validate_code", to: "password_reset#validate_code", as: :validate_code
  get "reset_password", to: "password_reset#reset_password", as: :reset_password
  patch "update_password", to: "password_reset#update_password", as: :update_password
  post "resend_code", to: "password_reset#resend_code", as: :resend_code

  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "profile", to: "profile#show", as: :profile
  get "settings/change_profile_picture", to: "settings#change_profile_picture", as: :change_profile_picture
  patch "settings/update_profile_picture", to: "settings#update_profile_picture"
  get "settings/change_password", to: "settings#change_password", as: :change_password
  patch "settings/update_password", to: "settings#update_password"

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
