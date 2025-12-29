Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root 'home#index'
    devise_for :users, path: '', controllers: { sessions: 'sessions' }
    resources :users, only: [:show, :edit, :update]
    namespace :admin do
      root 'dashboard#index'
      resources :users, only: [:index, :new, :create, :show, :edit, :update] do
        member do
          patch :soft_delete
          patch :update_role
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :suppliers, only: [:index, :create, :new, :edit, :update] do
        member do
          patch :soft_delete
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :places, only: [:index, :new, :create, :show, :edit, :update] do
        member do
          patch :soft_delete
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :sportfields, only: [:index, :new, :create, :edit, :update]
    end
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end

  namespace :api do
    namespace :v1 do
      resources :places, only: [:index, :show]
      resources :place_sports, only: [:index]
      get 'schedules', to: 'schedules#index'
      resources :bookings, only: [:create, :show]
      get 'place_managers', to: 'place_managers#index'
      resources :product_brands, only: [:index]
      resources :products, only: [:index, :show]
      resources :users, only: [:show, :update]
      resource :sessions, only: [:create], path: 'login', controller: 'sessions'
    end
  end
end
