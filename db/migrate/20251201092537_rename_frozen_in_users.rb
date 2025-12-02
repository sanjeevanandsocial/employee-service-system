class RenameFrozenInUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :frozen, :is_frozen
  end
end
