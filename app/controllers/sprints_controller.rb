class SprintsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Sprint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sprints }
    end
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
    @sprint = Sprint.find(params[:id])
    
    @stages = Stage.find(:all)
    
    # Add up storypoints of all tasks in sprint
    @target_storypoints = Task.sum(:sp, :conditions => ['sprint_id = ?', @sprint.id])

    @completed_storypoints = count_completed_tasks(@sprint.tasks)
    
    @burndown_data = @sprint.get_burndown_data
    
    @number_of_days = ((@sprint.end_time - @sprint.start_time) / 1.day).to_i
    
    @users = User.find(:all, :conditions => ["id != ?", current_user.id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /sprints/new
  # GET /sprints/new.json
  def new
    @sprint = Sprint.new
    
    last_sprint = Sprint.find(:first, :order => "end_time DESC")
    
    @start_datetime = last_sprint.end_time
    @start_date = @start_datetime.strftime("%d-%m-%Y")
    
    @end_datetime = (last_sprint.end_time + 7.days)
    @end_date = @end_datetime.strftime("%d-%m-%Y")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /sprints/1/edit
  def edit
    @sprint = Sprint.find(params[:id])
    
    last_sprint = Sprint.find(:first, :order => "end_time DESC")
    
    @start_datetime = @sprint.start_time
    @start_date = @start_datetime.strftime("%d-%m-%Y")
    
    @end_datetime = @sprint.end_time
    @end_date = @end_datetime.strftime("%d-%m-%Y")
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = Sprint.new(params[:sprint])
    @sprint.user_id = current_user.id
    
    start_time = params[:date_start]
    end_time = params[:date_end]
    
    @sprint.start_time = start_time
    @sprint.end_time = end_time
        
    respond_to do |format|
      if @sprint.save
        format.html { redirect_to @sprint, notice: 'Sprint was successfully created.' }
        format.json { render json: @sprint, status: :created, location: @sprint }
      else
        format.html { render action: "new" }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sprints/1
  # PUT /sprints/1.json
  def update
    @sprint = Sprint.find(params[:id])
    
    start_time = params[:date_start]
    end_time = params[:date_end]
    
    @sprint.start_time = start_time
    @sprint.end_time = end_time
    
    @sprint.save
    
    
    respond_to do |format|
      if @sprint.update_attributes(params[:sprint])
        format.html { redirect_to @sprint, notice: 'Sprint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    @sprint = Sprint.find(params[:id])
    @sprint.destroy

    respond_to do |format|
      format.html { redirect_to sprints_url }
      format.json { head :no_content }
    end
  end
  
  def add_task
  	@sprint = Sprint.find(params[:id])
  	@errors = Array.new 
  	
  	if !params[:task_id].nil?
  		@task = Task.find(params[:task_id])
	  	if !@task.nil? 
	  		if @task.sprint_id.nil?
				@task.sprint = @sprint
				@task.save
			else
				@errors.push('Task already in sprint.')
			end
	  	else
	  		@errors.push('Task not found.')
	  	end
	end
	 
	respond_to do |format|
	  format.json { render json: { :task => @task, :errors => @errors } }
    end
  end
  
  def remove_task
  	@errors = Array.new 
  	
  	if !params[:task_id].nil?
  		@task = Task.find(params[:task_id])
	  	if !@task.nil? 
  			@task.sprint_id = nil
			@task.save
	  	else
	  		@errors.push('Task not found.')
	  	end
	end
	 
	respond_to do |format|
	  format.json { render json: { :task => @task, :errors => @errors } }
    end
  end
  
  def assign_stage
  	@sprint = Sprint.find(params[:id])
  	
  	if !params[:task_stage_id].nil?
  		@user = User.find(params[:user_id])
  		
  		if !@user.nil?
	  		@assignment = Assignment.where(:user_id => @user.id, :task_stage_id => params[:task_stage_id])
	  		
	  		@task_stage = TaskStage.find(params[:task_stage_id])
	  		
	  		if !@task_stage.nil? && @assignment.empty?
	  			@assignment = Assignment.new
				@assignment.task_stage = @task_stage
				@assignment.user = @user
				
				if @task_stage.status == 'open'
					@task_stage.status = 'started'
					@task_stage.save
				end
				
		  		@assignment.save
		  	end
	  	end
	 end
	 
	 respond_to do |format|
      	format.html { redirect_to @sprint }
      	format.json { render json: @assignment }
      end
  end
  
  def remove_assignment
  	@sprint = Sprint.find(params[:id])
  	
  	if !params[:task_stage_id].nil? && !params[:user_id].nil?
  		@assignment = Assignment.where(:user_id => params[:user_id], :task_stage_id => params[:task_stage_id]).first
  		
  		if !@assignment.nil?
	  		@assignment.destroy
	  	end
	 end
	 
	 respond_to do |format|
      	format.html { redirect_to @sprint }
      	format.json { render json: @assignment }
      end
  end
  
  
  def change_status
  	if !params[:task_stage_id].nil?
  		@task_stage = TaskStage.find(params[:task_stage_id])
  		if !@task_stage.nil?
			@task_stage.status = params[:task_stage_status]
			@task_stage.save
	  	end
	 end
	 
	 sprint = @task_stage.task.sprint 
	 
	 @target_sp = Task.sum(:sp, :conditions => ['sprint_id = ?', sprint.id])
	 @sp_completed = sprint.count_completed_sp
	 @percentage = "%.0f" % (100 - ((@sp_completed / @target_sp) * 100))
	 
	 @burndown_data = sprint.get_burndown_data
	 
	 respond_to do |format|
      	format.html # new.html.erb
      	format.json { render json: {:sp_completed => @sp_completed, :target_sp => @target_sp, :percentage => @percentage, :burndown_data => @burndown_data } }
      end
  end
  
end
