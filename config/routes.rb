LadderApp::Application.routes.draw do
  root 'homes#show'

  match '/auth/:provider/callback', to: 'sessions#create', via: %w{get post}

  resource :home, only: [:show]
  resources :players, only: [:index, :create, :show, :destroy]
  resources :settings, only: [:index]
  resources :results, only: [:index, :create, :destroy] do
    collection do
      get :undo
    end
  end

  resource :ping, only: [:show]

  resource :test, only: [:show]
end
