Rails.application.routes.draw do
  
  devise_for :users
  
  devise_for :admins, controllers: {
  sessions: "admin/sessions"
  }
  
  root :to => "homes#top"
  get "home/about" => "homes#about"
  get "home/logout" => "homes#logout"
  
  resources :users,only:[:show, :edit, :update] do
    get 'follows' => 'relationships#follows', as: 'follows'
    get 'followers' => 'relationships#followers', as: 'followers'
    resources :relationships, only: [:create, :destroy]
  end
  
  resources :posts do
    resource :post_comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end
  
  resources :groups,only:[:create, :index, :show, :edit, :update, :destroy] do
    resources :group_comments,only:[:create, :destroy]
  end
  
  # namespace :admin do
    
  # end
end
