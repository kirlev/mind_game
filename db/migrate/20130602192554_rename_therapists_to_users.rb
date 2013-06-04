class RenameTherapistsToUsers < ActiveRecord::Migration
  def change
  	rename_table :therapists, :users
  end
end
