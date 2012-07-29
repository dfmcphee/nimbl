class Increment < ActiveRecord::Base
  attr_accessible :completed, :sprint_id
  
  belongs_to :sprint
  
  def self.add_sprint_increment
  	logger.info 'Increment hit.'
  	sprints = Sprint.find(:all, :conditions => ['start_time < ? AND end_time > ?', today, today])
  	sprints.each do |sprint|
	  	increment = Increment.new
	  	increment.sprint = sprint
	  	target_storypoints = Task.sum(:sp, :conditions => ['sprint_id = ?', sprint.id])
	  	increment.completed = sprint.count_completed_sp
	  	increment.save
  	end
  end
end