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
  
  resources :articles do
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    member do
      get "unsubscribe" #退会画面
      patch "withdraw" #退会処理.is_deletedを更新
    end
  end

  resources :themes, only: [:index, :new, :create] do
    resources :answers, except: [:edit, :update] do
      resources :comments, only: [:create, :destroy]
    end
  end
end
