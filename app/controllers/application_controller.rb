class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def count_completed_tasks(tasks)
  	sp_complete = 0
	tasks.each do |task|
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
		if stages_complete === stages_required
			sp_complete = sp_complete + task.sp
		end
	end
	return sp_complete
  end
end
