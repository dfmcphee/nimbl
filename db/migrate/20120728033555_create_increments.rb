class CreateIncrements < ActiveRecord::Migration
  def change
    create_table :increments do |t|
      t.integer :sprint_id
      t.float :completed

      t.timestamps
    end
  end
end
