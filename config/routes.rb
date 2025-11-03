Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root 'home#index'
    devise_for :users, controllers: { sessions: "sessions" }
    resources :users, only: [:show, :edit, :update]
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end

  namespace :api do
    namespace :v1 do
      resources :places, only: [:index, :show]
    resources :place_sports, only: [:index]
    get 'schedules', to: 'schedules#index'
    resources :bookings, only: [:create, :show]
    get 'place_managers', to: 'place_managers#index'
    end
  end
end
