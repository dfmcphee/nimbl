class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :stage_id

      t.timestamps
    end
  end
end
