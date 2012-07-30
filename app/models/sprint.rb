class Sprint < ActiveRecord::Base
  has_many :tasks
  has_many :increments
  belongs_to :user
  attr_accessible :team_id, :user_id, :name
  
  validates :name, :start_time, :end_time, :presence => true
  
  def count_completed_sp
  	sp_complete = 0
	self.tasks.each do |task|
		stages_complete = 0
		stages_required = 0
		task.task_stages.each do |stage|
			if stage.required
				stages_required = stages_required + 1
			end
			if stage.status == 'finished'
				stages_complete = stages_complete + 1
			end
		end
		if stages_complete === stages_required && !task.sp.nil?
			sp_complete = sp_complete + task.sp
		end
	end
	return sp_complete
  end
  
  def get_burndown_data
  	target_sp = Task.sum(:sp, :conditions => ['sprint_id = ?', self.id])

    completed_sp = self.count_completed_sp
  
  	burndown_data = Array.new 
    burndown_data.push([0, target_sp])
    
    i = 1
    self.increments.each do |increment|
    	burndown_data.push([i, target_sp - increment.completed])
    	i+=1
    end
    
    burndown_data.push([i, target_sp - completed_sp])
    
    return burndown_data
  end
end