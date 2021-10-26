Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles#, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :categories, except: [:destroy]

  namespace :api, :defaults => {:format => :json} do
    resources :users
    resources :articles
    post 'signup', to: 'users#create'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

end
