Rails.application.routes.draw do
  root 'welcome#index'

  resources :activities
  resources :users, only: [:index, :show]

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

  resources :departments,   only: [:index, :show, :new, :create, :destroy] do
    resources :activities,  only: [:index], controller: 'departments/activities'
  end

  resources :roles,         only: [:index, :new, :create, :destroy]

  resources :boards do
    resources :departments, only: [:show]
    resources :terms,       only: [:new, :create, :destroy]
  end

  get '/news' => 'welcome#news'
  get '/log' => 'welcome#log'
  get '/about' => 'welcome#about'
  get '/team' => 'welcome#team'
  get '/contact' => 'welcome#contact'
  get '/news' => 'welcome#news'
  get '/log' => 'welcome#log'
  get '/uminhocup' => redirect('https://cesium.typeform.com/to/mcF2UI')
end
