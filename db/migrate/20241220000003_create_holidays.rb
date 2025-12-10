class CreateHolidays < ActiveRecord::Migration[7.2]
  def change
    create_table :holidays do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.text :description
      t.timestamps
    end
    
    add_index :holidays, :date, unique: true
  end
end