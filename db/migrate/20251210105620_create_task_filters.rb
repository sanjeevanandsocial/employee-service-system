class CreateTaskFilters < ActiveRecord::Migration[7.2]
  def change
    create_table :task_filters do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :filter_params

      t.timestamps
    end
  end
end
