class Task < ActiveRecord::Base
  belongs_to :stage
  belongs_to :user
  belongs_to :sprint
  attr_accessible :description, :name, :stage_id, :user_id, :sprint_id
end
