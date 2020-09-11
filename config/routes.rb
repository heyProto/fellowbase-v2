Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/report', to: "reports#index", as: "report"
  get '/links', to: "reports#all"
  get '/links/all', to: "reports#all", as: "all_digital_asset"
  get '/links/successful', to: "reports#successful", as: "successful_digital_asset"
  get '/links/errored', to: "reports#errored", as: "errored_digital_asset"
  get '/links/with-no-data', to: "reports#with_no_data", as: "digital_asset_with_no_data"
  get '/links/search', to: "reports#search", as: "digital_asset_search"

  post '/user/set_selected_dimensions', to: "static_pages#set_selected_dimensions", as: "set_selected_dimensions"

  resources :events

  resources :user_invites, only: [:create, :destroy]

  resources :digital_assets, only: [:new, :edit, :index, :create, :update, :destroy], path: 'digital_assets'

  resources :projects, only: [:new, :edit, :index, :create, :update, :destroy]


  devise_for :users,
             controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                              registrations: 'users/registrations'}
  namespace :admin do
    resources :users, only: [:index, :update, :new]
    resources :fellows, only: [:update, :index, :create, :destroy, :new]
    resources :ref_targets, only: [:index, :create, :update, :destroy, :new]
    resources :ref_impacts, only: [:index, :create, :update, :destroy, :new]
    resources :ref_partners, only: [:index, :create, :update, :destroy, :new]
  end

  resources :static_pages, only: [:index], path: 'home'
  root 'static_pages#home'
end
