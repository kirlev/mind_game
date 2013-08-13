class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :phone_number, :integer
    add_column :users, :injury, :string
    add_column :users, :last_login, :datetime
  end
end
