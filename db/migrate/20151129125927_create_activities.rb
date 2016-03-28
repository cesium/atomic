class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name, limit: 75
      t.string :location
      t.text :description
      t.integer :total_rating
      t.decimal :member_cost, precision: 5, scale: 2
      t.decimal :guest_cost,  precision: 5, scale: 2
      t.date :start_date
      t.date :end_date
      t.boolean :coffee_break
      t.attachment :poster

      t.references :activity,   index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
