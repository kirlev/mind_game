class CreateTherapists < ActiveRecord::Migration
  def change
    create_table :therapists do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :hospital_name

      t.timestamps
    end
  end
end
