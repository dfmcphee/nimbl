class TasksController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all(:conditions => ['sprint_id IS NULL'])
    @sprints = Sprint.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    @sprints = Sprint.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    
    @task_stages = Array.new
    
    stages = Stage.find(:all)
    
    stages.each do |stage|
    	task_stage = TaskStage.new
    	task_stage.stage = stage
    	task_stage.task = @task
    	task_stage.status = 'open'
    	
    	@task_stages.push(task_stage)
    end
    
    @sprints = Sprint.find(:all)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @task_stages = TaskStage.where(:task_id => @task.id)
    @sprints = Sprint.find(:all)
  end
  
  def edit_row
  	@task = Task.find(params[:id])
  	@task_stages = TaskStage.where(:task_id => @task.id)
    @sprints = Sprint.find(:all)
    
    render :layout => false
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    
    required_stages = params[:stages].collect {|id| id.to_i}
    stages = Stage.find(:all)
    
    stages.each do |stage|
    	task_stage = TaskStage.new
    	task_stage.stage = stage
    	task_stage.task = @task
    	task_stage.status = 'open'
    	
    	if required_stages.include?(stage.id)
    		task_stage.required = true
    	else
    		task_stage.required = false
    	end
    	
    	task_stage.save
    end
    
    @task.user_id = current_user.id 
    
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
end
