class RemoveStageFromAssigments < ActiveRecord::Migration
  def up
  	remove_column :assignments, :stage_id
  	remove_column :assignments, :task_id
  	remove_column :assignments, :status
  	add_column :assignments, :task_stage_id, :integer
  end

  def down
  	add_column :assignments, :stage_id, :integer
  	add_column :assignments, :task_id, :integer
  	add_column :assignments, :status, :string
  	remove_column :assignments, :task_stage_id
  end
end
