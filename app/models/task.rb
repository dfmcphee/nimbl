class Task < ActiveRecord::Base
  belongs_to :stage
  belongs_to :user
  belongs_to :sprint
  
  has_many :assignments
  has_many :users, :through => :assignments
  
  attr_accessible :description, :name, :stage_id, :user_id, :sprint_id, :hour_estimate, :sp, :bvp
end
