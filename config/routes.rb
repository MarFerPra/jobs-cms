Rails.application.routes.draw do
  resources :jobs do
    match 'set_active', to: :member, via: [:post, :put, :patch] # Activate/Deactivate
    get :page, on: :collection # Get all jobs paginated
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
