Rails.application.routes.draw do
  root "pages#home"
  get 'signup', to: "users#new"
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :problems
  get 'last_submission',to: 'submissions#last_submission'
  resources :submissions, only: [:show]
  resources :user_problem_likes, only: [:create]
  get 'like', to: 'users#toggle_like'
  # post 'solve', to: 'users#solve_problem'
  # post 'problems/difficulty', to: 'problems#get_problems_by_difficulty'
  resources :categories
  post 'submissions', to: 'submissions#submit'
end
