Tickets::Application.routes.draw do
  root :to => "tickets#index"

  resources :tickets
  resources :groups
  resources :users
end
