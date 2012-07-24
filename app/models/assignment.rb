class Assignment < ActiveRecord::Base
  attr_accessible :task_stage_id, :user_id
  
  belongs_to :user
  belongs_to :task_stage
end