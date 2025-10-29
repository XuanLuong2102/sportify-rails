Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root 'home#index'
    devise_for :users, controllers: { sessions: "sessions" }
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
end
