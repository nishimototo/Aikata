Rails.application.routes.draw do

  get 'users/show'
  get 'users/edit'
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  root "homes#top"
  resources :articles
  resources :users, only: [:show, :edit, :update] do

  end
end
