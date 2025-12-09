class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :status, default: 'planned'

      t.timestamps
    end
  end
end
