Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Employee routes (admin + non-admin)
  resources :employees, only: [:index] do
    member do
      get :attendance
    end
  end

  # Admin-only routes
  authenticate :user, ->(u) { u.admin? } do
    resources :employees, except: [:index] do
      member do
        patch :freeze_account
      end
    end
  end

  # Root route
  root "employees#index"

  # Health + PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
