Rails.application.routes.draw do
  root "pages#home"
  get 'signup', to: "users#new"
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :problems, only: [:new, :create, :show, :index, :destroy]
  resources :categories
end
