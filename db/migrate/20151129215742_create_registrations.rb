class CreateRegistrations < ActiveRecord::Migration[4.2]
  def change
    create_table :registrations do |t|
      t.references :activity
      t.references :user

      t.timestamps null: false
    end
  end
end
