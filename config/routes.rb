Rails.application.routes.draw do
  root 'welcome#index'

  resources :users, only: [:index, :show]

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  namespace :blog do
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end

    resources :articles, path: 'news' do
      resources :comments, only: [:create, :destroy]
    end
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
end
