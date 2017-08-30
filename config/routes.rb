Rails.application.routes.draw do
  root 'welcome#index'

  resources :activities
  scope module: 'activities' do
    get 'activities/:activity_id/register',
      to: 'registrations#create',
      as: 'activity_registration'
    get 'activities/:activity_id/register_cancel',
      to: 'registrations#destroy',
      as: 'activity_registration_cancel'
    get 'activities/:activity_id/participants',
      to: 'registrations#index',
      as: 'activity_participants'
    patch 'activities/:activity_id/participants/:participant_id',
      to: 'registrations#update',
      as: 'confirm_participant'
  end

  resources :users, only: [:index, :show]

  get '/sign_in' , to: 'sessions#new', as: 'sign_in'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'
  get '/auth/failure', to: redirect('/')
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :departments,   only: [:index, :show, :new, :create, :destroy] do
    resources :activities,  only: [:index], controller: 'departments/activities'
  end

  resources :roles,         only: [:index, :new, :create, :destroy]

  resources :boards do
    resources :departments, only: [:show]
    resources :terms,       only: [:new, :create, :destroy]
  end

  get '/news', to: 'welcome#news'
  get '/log', to: 'welcome#log'
  get '/about', to: 'welcome#about'
  get '/team', to: 'welcome#team'
  get '/contact', to: 'welcome#contact'
  get '/news', to: 'welcome#news'
  get '/log', to: 'welcome#log'
  get '/partners', to: 'welcome#partners'
  get '/uminhocup', to: redirect('https://cesium.typeform.com/to/mcF2UI')
end
