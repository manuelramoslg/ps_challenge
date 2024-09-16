Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  resources :exams do
    resource :attempt, only: [ :show ], controller: "exam_attempts" do
      member do
        post "start"
        post "submit"
        post 'assign'
        get "result"
      end
    end
  end
end
