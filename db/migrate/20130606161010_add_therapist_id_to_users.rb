class AddTherapistIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :therapist_id, :integer
  end
end
