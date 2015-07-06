Rails.application.routes.draw do

  resources :boletos

  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  
  get    'users_hack' => 'users#index'
  put    'users_hack' => 'users#update'
  
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
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
end
