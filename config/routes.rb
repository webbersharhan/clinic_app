Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :patients, module: 'patients', only: [:show, :create, :update, :destroy] do
        resources :appointments, only: [:index, :show, :create, :update, :destroy]
      end
      
      resources :doctors, module: 'doctors' do
        get 'timeslots', action: :index, controller: 'timeslots'
        resources :appointments, only: [:index, :show, :create, :update, :destroy]
        resources :availabilities, only: [:index, :show, :create, :update, :destroy], controller: 'doctor_availabilities'
      end
    end
  end
end
