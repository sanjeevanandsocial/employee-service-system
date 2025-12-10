class CreateProjectEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :project_employees do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :project_employees, [:project_id, :user_id], unique: true
  end
end
