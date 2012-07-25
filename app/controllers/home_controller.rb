class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @sprint = Sprint.last
    
    @stages = Stage.find(:all)
    
    # Add up storypoints of all tasks in sprint
    @target_storypoints = Task.sum(:sp, :conditions => ['sprint_id = ?', @sprint.id])
  end
end
