class AddIndexToPatientsUsername < ActiveRecord::Migration
  def change
  	add_index :patients, :username, unique: true
  end
end
