Rails3BootstrapDeviseCancan::Application.routes.draw do
  root :to => "home#index"
  
  match '/sprints/:id/add_task' => 'sprints#add_task'
  
  match '/sprints/remove_task' => 'sprints#remove_task'
  
  match '/sprints/:id/assign_stage' => 'sprints#assign_stage'
  
  match '/sprints/change_status' => 'sprints#change_status'
  
  resources :sprints

  resources :stages

  resources :tasks

  authenticated :user do
    root :to => 'home#index'
  end

  devise_for :users
  
  resources :users, :only => [:show, :index]
end
