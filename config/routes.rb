Rails.application.routes.draw do

  resources :boletos, except: [:destroy]

  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  

  #Authentication
  resources :passwords, controller: 'passwords', only: [:create, :new]
  resource :session, controller: 'sessions', only: [:create]

  resources :users, controller: 'users', only: [:create] do
    resource :password,
      controller: 'passwords',
      only: [:create, :edit, :update]
  end

  get 'sign_in' => 'sessions#new'
  delete 'sign_out' => 'sessions#destroy'
  get 'sign_up' => 'users#new'

  get 'user_setting_senders' => 'user_settings#senders'
  put 'user_setting_senders' => 'user_settings#update_senders'

end
