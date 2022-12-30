# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resources :reports
  resources :imports
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  authenticated :user, ->(u) { Rails.env.development? || u.admin? } do
    mount RailsAdmin::Engine => '/admin', as: :rails_admin
    mount Sidekiq::Web => '/sidekiq'
  end

  # Webhooks
  namespace :webhooks do
    post '/stripe' => 'stripe#create'
  end

  # Billing portal sessions
  resources :billing_portal_sessions, only: [:create]
  resources :checkout_portal_sessions, only: %i[new create] do
    collection do
      get :success
    end
  end

  get '/home/revenues' => 'home#revenues'
  get '/home/expenses' => 'home#expenses'
  get '/home/chart' => 'home#chart'
  get '/home/dre' => 'home#dre'
  get '/home/outcome' => 'home#outcome'

  # Resources
  resources :account_invitations do
    member do
      put 'accept'
      delete 'reject'
    end
  end
  resources :transactions do
    resources :attachments, only: %i[index new create destroy], on: :member, module: :transactions
    member do
      get :details
      patch :toggle
      put :toggle
      patch :duplicate
      put :duplicate
      get :move_to
      get :setup_installments
      get :setup_recurrence
      put :create_installments
      patch :create_installments
      put :create_recurrence
      patch :create_recurrence
      get :change_installments
      get :destroy_dialog
    end
    collection do
      get :add
      get :totalizer
      get :chart
      get :outcome
      get :revenues
      get :expenses
      get :balance
    end
  end
  resources :bank_accounts do
    member do
      put :turn_default
      patch :turn_default
    end
  end
  resources :categories
  resources :cost_centers
  resources :contacts
  resources :imports
  resources :account_users
  resources :notifications, only: %i[index destroy] do
    member do
      put :mark_as_read
      put :mark_as_unread
    end
    collection do
      put :dismiss_all
      get :alert
    end
  end

  get '/reports' => 'reports#index'

  # User settings
  get '/user_settings/edit' => 'user_settings#edit'
  put '/user_settings'      => 'user_settings#update'
  patch '/user_settings'    => 'user_settings#update'
  put '/user_settings/switch_account' => 'user_settings#switch_account'

  # Account settings
  get '/account_settings/edit' => 'account_settings#edit'
  put '/account_settings'      => 'account_settings#update'
  patch '/account_settings'    => 'account_settings#update'

  # Static
  scope controller: :static do
    get :about
    get :terms
    get :privacy
  end

  # Root Path
  root 'home#index'
end
