Rails3BootstrapDeviseCancan::Application.routes.draw do
  root :to => "home#index"
  
  match '/sprints/:id/add_task' => 'sprints#add_task'
  
  resources :sprints

  resources :stages

  resources :tasks

  authenticated :user do
    root :to => 'home#index'
  end

  devise_for :users
  
  resources :users, :only => [:show, :index]
end
