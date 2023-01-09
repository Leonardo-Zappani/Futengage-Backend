Rails.application.routes.draw do
  resources :histories
  resources :configs
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :futengages
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "futengages#index"
  get "home" => "futengages#index"

end
