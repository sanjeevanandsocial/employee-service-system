class CreateUserPermissions < ActiveRecord::Migration[7.2]
  def change
    create_table :user_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :permission_key, null: false
      t.string :permission_value, null: false

      t.timestamps
    end

    add_index :user_permissions, [:user_id, :permission_key], unique: true
  end
end