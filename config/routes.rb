Rails.application.routes.draw do
  root 'welcome#index'

  get '/about', to: 'welcome#about'
  get '/contact', to: 'welcome#contact'
  get '/log', to: 'welcome#log'
  get '/team', to: 'welcome#team'

  resources :partners,      except: :show
  
  resources :users, only: [:index, :show]

  get '/sign_in' , to: 'sessions#new', as: 'sign_in'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'

  get '/auth/failure', to: redirect('/')
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :activities
  resources :departments, only: [:index, :show, :new, :create, :destroy]

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
end
