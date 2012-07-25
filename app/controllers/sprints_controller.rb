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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /sprints/new
  # GET /sprints/new.json
  def new
    @sprint = Sprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sprint }
    end
  end

  # GET /sprints/1/edit
  def edit
    @sprint = Sprint.find(params[:id])
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = Sprint.new(params[:sprint])
    @sprint.user_id = current_user.id
        
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
  
  def assign_stage
  	@sprint = Sprint.find(params[:id])
  	
  	if !params[:task_stage_id].nil?
  		@assignment = Assignment.where(:user_id => current_user.id, :task_stage_id => params[:task_stage_id])
  		
  		@task_stage = TaskStage.find(params[:task_stage_id])
  		
  		if !@task_stage.nil? && @assignment.empty?
  			@assignment = Assignment.new
			@assignment.task_stage = @task_stage
			@assignment.user = current_user
	  		@assignment.save
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
	 
	 respond_to do |format|
      	format.html # new.html.erb
      	format.json { render json: @task_stage }
      end
  end
  
end
