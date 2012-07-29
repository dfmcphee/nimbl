class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
  	today = Date.today
  	@sprint = Sprint.find(:first, :conditions => ['start_time < ? AND end_time > ?', today, today])
  	
  	if !@sprint.nil?
	    @stages = Stage.find(:all)
	    
	    # Add up storypoints of all tasks in sprint
	    @target_storypoints = Task.sum(:sp, :conditions => ['sprint_id = ?', @sprint.id])
	    
	    # Add up all points completed so far
	    @completed_storypoints = count_completed_tasks(@sprint.tasks)
	    
	    @burndown_data = @sprint.get_burndown_data
	    
	    @number_of_days = ((@sprint.end_time - @sprint.start_time) / 1.day).to_i
    end
  end
end