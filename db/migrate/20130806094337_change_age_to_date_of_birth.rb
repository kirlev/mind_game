class ChangeAgeToDateOfBirth < ActiveRecord::Migration
  def up
  	rename_column :users, :age, :date_of_birth
  end

  def down
  	rename_column :users, :date_of_birth, :age
  end
end
