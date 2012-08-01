class AddBackloggedToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :backlogged, :boolean, :default => false
  end
end
