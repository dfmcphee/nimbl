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
  	
  	if !params[:task_id].nil?
  		@task = Task.find(params[:task_id])
	  	if !@task.nil?
			@task.sprint = @sprint
	  		if @task.save
	  			format.json { render json: @sprint, status: :created, location: @sprint }
	  		else
	  			format.json { render json: @sprint.errors, status: :unprocessable_entity }
	  		end
	  	end
	 else
	  	format.json { render json: @sprint.errors, status: :unprocessable_entity }
	 end
  end
  
  def assign_stage
  	@sprint = Sprint.find(params[:id])
  	
  	if !params[:task_id].nil?
  	    @assignment = Assignment.new 
  		@task = Task.find(params[:task_id])
  		if !@task.nil?
			@assignment.task = @task
			@assignment.user = current_user
	  		@assignment.save
	  	end
	 end
	 
	 respond_to do |format|
      	format.html # new.html.erb
      	format.json { render json: @sprint }
      end
  end
  
end
