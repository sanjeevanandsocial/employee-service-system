class AddGenderAndAgeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :gender, :integer, default: 0, null: false
    add_column :users, :age, :integer
  end
end
