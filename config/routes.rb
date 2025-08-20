Rails.application.routes.draw do
  resources :parties do
    resources :party_components, only: [:index, :new, :create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # root "posts#index"
end
