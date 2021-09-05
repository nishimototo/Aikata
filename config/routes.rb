Rails.application.routes.draw do

  get 'articles/index'
  get 'articles/show'
  get 'articles/new'
  get 'articles/edit'
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

 root "articles#index"
 resources :articles
end
