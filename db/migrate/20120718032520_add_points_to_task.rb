class AddPointsToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :sp, :float
    add_column :tasks, :bvp, :float
    add_column :tasks, :hour_estimate, :float
  end
end
