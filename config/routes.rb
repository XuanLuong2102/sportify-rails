Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: redirect('/admin/sign_in')
    # devise_for :users, path: '', controllers: { sessions: 'sessions' }
    # resources :users, only: [:show, :edit, :update]
    
    # ========================================
    # Agency namespace routes
    # ========================================
    namespace :agency do
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'sign_in',
          sign_out: 'sign_out',
          sign_up: 'sign_up'
        }, controllers: { sessions: 'agency/sessions' }
      
      root 'dashboard#index'
      
      # Dashboard
      get 'dashboard', to: 'dashboard#index'
      
      # Orders management with status filtering
      resources :orders, only: [:index, :show, :update] do
        member do
          patch :confirm
          patch :ship
          patch :complete
          patch :return
          get :delivery_slip
        end
        collection do
          get :pending
          get :confirmed
          get :shipping
          get :completed
          get :returned
        end
      end
      
      # Products management (disabled - use product_listings instead)
      # resources :products, only: [:index, :show, :edit, :update] do
      #   get :deleted, on: :collection
      # end
      
      # Product listings for this agency's places
      resources :product_listings, only: [:index, :new, :create, :show] do
        member do
          patch :soft_delete
          patch :restore
        end
      end
      
      # Stock requests (for new products and imports)
      resources :stock_requests, only: [:index, :new, :create, :show] do
        member do
          patch :cancel
        end
        collection do
          get :pending
          get :approved
          get :rejected
        end
      end
      
      # Sport fields management
      resources :sportfields, only: [:index, :show, :edit, :update] do
        member do
          patch :update_schedule
          patch :set_maintenance
        end
        collection do
          get :schedules
        end
      end
      
      # Place sports management
      resources :place_sports, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
        member do
          patch :soft_delete
          patch :restore
          patch :toggle_maintenance
        end
      end
      
      # Bookings management with status filtering
      resources :bookings, only: [:index, :show, :update] do
        member do
          patch :approve
          patch :reject
          patch :confirm_payment
          patch :complete
          patch :cancel
        end
        collection do
          get :pending
          get :approved
          get :unpaid
          get :completed
          get :cancelled
        end
      end
      
      # Schedules - weekly calendar view of confirmed bookings
      resources :schedules, only: [:index]
    end
    
    # ========================================
    # Admin namespace routes
    # ========================================
    namespace :admin do
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'sign_in',
          sign_out: 'sign_out'
        }, controllers: { sessions: 'admin/sessions' }
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

        resources :place_managers, only: [:index, :new, :create, :edit, :update, :destroy]
        resources :place_sports, only: [:index, :new, :create, :edit, :update] do
          member do
            patch :soft_delete
            patch :restore
          end
        end
        resources :product_listings, only: [:index, :new, :create, :edit, :update, :destroy]do
          member do
            patch :soft_delete
            patch :restore
          end
        end
      end
      resources :sportfields, only: [:index, :new, :create, :edit, :update]
      resources :products, only: %i[index new create show edit update destroy] do
        member do
          patch :soft_delete
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :product_sizes, only: [:index, :new, :create, :edit, :update] do
        member do
          patch :soft_delete
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :product_colors, only: [:index, :new, :create, :edit, :update] do
        member do
          patch :soft_delete
          patch :restore
        end
        get :deleted, on: :collection
      end
      resources :distributions, only: [:index] do
        member do
          patch :approve
          patch :reject
        end
      end
      resources :stock_inbounds, only: [:index, :new, :create, :show] do
        get :get_product_variants, on: :collection
      end
      resources :orders, only: [:index, :show]
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
