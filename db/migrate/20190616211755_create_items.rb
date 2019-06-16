class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.string :status
      t.datetime :due_date
      t.integer :list_id

      t.timestamps
    end
  end
end
