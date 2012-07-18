class AddSprintToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :sprint_id, :integer
  end
end
