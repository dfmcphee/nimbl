class AddHoursCompleteToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :hours_complete, :float
  end
end
