Rails.application.routes.draw do
  
  devise_for :users, controllers: {registrations: 'registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'

  resources :users, only: [:show, :index]
  resources :friendships, only: [:create, :destroy, :accept] do
  	member do 
  		put :accept
  	end
  	end

  	resources :posts, only: [:create, :edit, :update, :destroy]
    resources :activities, only: [:index]
end