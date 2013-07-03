class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :time
      t.integer :repeats
      t.integer :ratio

      t.timestamps
    end
  end
end
