class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.string :games_id
      t.string :details

      t.timestamps
    end
  end
end
