Rails.application.routes.draw do

  root to: 'home#index'
  devise_for :users

  resources :events, except: :index
  get "calendar/:date", to: "calendar#show", as: "calendar"
end
