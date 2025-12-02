class AddRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer, default: 1
    add_column :users, :frozen, :boolean, default: false
  end
end
