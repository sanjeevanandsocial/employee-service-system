class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.integer :priority, default: 0
      t.date :due_date
      t.integer :status, default: 0
      t.integer :category, default: 0
      t.string :estimated_time

      t.timestamps
    end
  end
end
