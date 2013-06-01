class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :password_digest

      t.timestamps
    end
  end
end
