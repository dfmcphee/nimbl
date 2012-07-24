class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :sprint
  
  has_many :assignments
  has_many :users, :through => :assignments
  
  has_many :task_stages
  
  attr_accessible :description, :name, :stage_id, :user_id, :sprint_id, :hour_estimate, :sp, :bvp
end
