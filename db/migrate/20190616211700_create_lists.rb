class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.string :description
      t.datetime :due_date
      t.integer :user_id

      t.timestamps
    end
  end
end
