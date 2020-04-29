Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: %i(new create show)

  resource :session, only: %i(new create destroy) 

  root to: 'sessions#new'
end
