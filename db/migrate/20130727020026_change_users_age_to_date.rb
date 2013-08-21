class ChangeUsersAgeToDate < ActiveRecord::Migration
  def up
  	remove_column :users, :age
  	add_column :users, :age, :date
  end

  def down
  	remove_column :users, :age
  	add_column :users, :age, :integer
  end
end
