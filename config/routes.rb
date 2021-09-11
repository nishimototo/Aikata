Rails.application.routes.draw do

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
  get "search" => "searches#search"

  namespace :admins do
    resources :users, only: [:index, :edit, :update]
  end

  resources :articles do
    resource :favorites, only: [:create, :destroy]
    resources :article_comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    member do
      get "unsubscribe" #退会画面
      patch "withdraw" #退会処理.is_deletedを更新
      get "follows"
      get "followers"
      get "my_answer"
    end
  end

  resources :themes, only: [:index, :new, :create] do
    resources :answers, except: [:edit, :update] do
      resources :rates, only: [:create]
      resources :comments, only: [:create, :destroy]
    end
  end

  resources :notifications, only: [:index]
end
