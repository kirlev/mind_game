class AddPatientIdToInstructions < ActiveRecord::Migration
  def change
  	add_column :instructions, :patient_id, :integer
  end
end
