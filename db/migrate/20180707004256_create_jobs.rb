class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :position
      t.string :company
      t.string :location
      t.text :description
      t.string :link
      t.string :contact
      t.attachment :poster

      t.timestamps null: false
    end
  end
end
