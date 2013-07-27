class ChangeUsersAgeToDate < ActiveRecord::Migration
  def up
  	change_column :users, :age, :date
  end

  def down
  	change_column :users, :age, :integer
  end
end
