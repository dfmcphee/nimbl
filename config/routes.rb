Nimbl::Application.routes.draw do
  root :to => "home#index"
  
  match '/sprints/:id/add_task' => 'sprints#add_task'
  
  match '/sprints/remove_task' => 'sprints#remove_task'
  
  match '/sprints/:id/assign_stage' => 'sprints#assign_stage'
  
  match '/sprints/:id/remove_assignment' => 'sprints#remove_assignment'
  
  match '/sprints/change_status' => 'sprints#change_status'
  
  match '/tasks/new_row' => 'tasks#new_row'
  
  match '/tasks/:id/edit_row' => 'tasks#edit_row'
  
  match '/tasks/:id/task_row' => 'tasks#task_row'
  
  match '/tasks/:id/update_hours' => 'tasks#update_hours'
  
  match '/tasks/:id/add_to_backlog' => 'tasks#add_to_backlog'
  
  match '/backlog' => 'tasks#backlog'
  
  resources :sprints
  

  resources :stages
  
  
  resources :tasks

  authenticated :user do
    root :to => 'home#index'
  end

  devise_for :users
  
  resources :users, :only => [:show, :index]
end
