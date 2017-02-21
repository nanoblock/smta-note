Rails.application.routes.draw do

  resources :users, except: [:destroy] do
    resources :notes, except: [:edit, :new] do 
      resources :comments, except: [:edit, :new]
      resources :favorites, except: [:edit, :new, :update]
    end
  end

  delete '/users/:id' => 'users#destroy', as: :destroy_user
  get '/users/activate/:id' => 'users#activate', as: :activate_user

  post 'sign_up' => 'users#create', as: :sign_up
  post 'login' => 'user_sessions#create', as: :login
  get 'logout' => 'user_sessions#destroy', as: :logout

  post 'accounts/password/reset' => 'users#reset_password'
  get 'accounts/password/token/:id' => 'users#reset_password_token'
  post 'accounts/password/reset/:id' => 'users#reset_password_update', as: :password_reset

end
