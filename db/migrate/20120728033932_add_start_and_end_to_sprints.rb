class AddStartAndEndToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :start_time, :datetime
    add_column :sprints, :end_time, :datetime
  end
end
