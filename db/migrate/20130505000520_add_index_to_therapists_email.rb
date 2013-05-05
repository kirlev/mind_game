class AddIndexToTherapistsEmail < ActiveRecord::Migration
  def change
  	add_index :therapists, :email, unique: true
  end
end
