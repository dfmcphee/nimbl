class Assignment < ActiveRecord::Base
  attr_accessible :stage_id, :task_id, :user_id
  
  belongs_to :user
  belongs_to :task
end
