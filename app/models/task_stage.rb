class TaskStage < ActiveRecord::Base
  attr_accessible :required, :stage_id, :status, :task_id
  belongs_to :task
  belongs_to :stage
  has_many :assignments
end
