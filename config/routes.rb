Rails.application.routes.draw do
  resources :pagamentos
  resources :teams
  resources :places
  resources :plaes
  resources :members
  resources :confirmations
  resources :matches
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :histories
  resources :configs
  resources :futengages
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "futengages#index"
  get "home" => "futengages#index"
  post "teams/create_match" => "teams#create_match"
  post "teams/create_place" => "teams#create_place"
  post "teams/add_member" => "teams#add_member"
  post "teams/new_both" => "teams#create_everything"
end
