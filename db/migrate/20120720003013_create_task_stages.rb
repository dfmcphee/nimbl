class CreateTaskStages < ActiveRecord::Migration
  def change
    create_table :task_stages do |t|
      t.integer :task_id
      t.integer :stage_id
      t.boolean :required
      t.string :status

      t.timestamps
    end
  end
end
