Rails.application.routes.draw do
  resources :users, except: [:destroy] do
    member do
      get :activate
    end
  end

  delete '/users/:id' => 'users#destroy', as: :destroy_user

  post 'login' => 'user_sessions#create'
  get 'logout' => 'user_sessions#destroy'

  post 'accounts/password/reset' => 'users#reset_password'
  get 'accounts/password/token/:id' => 'users#reset_password_token'
  post 'accounts/password/reset/:id' => 'users#reset_password_update', as: :password_reset

end
