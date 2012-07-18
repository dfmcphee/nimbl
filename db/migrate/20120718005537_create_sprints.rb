class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer :user_id
      t.integer :team_id

      t.timestamps
    end
  end
end
