Tickets::Application.routes.draw do
  root :to => "tickets#index"

  resources :tickets
  resources :groups do
    resources :users
  end
end
