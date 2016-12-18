Rails.application.routes.draw do
  resources :users, only: [:create]
  post 'authenticate', to: 'authentication#authenticate'

  resources :jobs do
    match 'set_active', to: :member, via: [:post, :put, :patch] # Activate/Deactivate
    get :page, on: :collection # Get all jobs paginated
  end

  resources :applications, only: [:index, :show, :create]

end
