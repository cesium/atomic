class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :activity
      t.references :user

      t.timestamps null: false
    end
  end
end
