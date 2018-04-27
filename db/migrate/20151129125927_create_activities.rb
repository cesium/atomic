class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.string :name, limit: 75
      t.string :location
      t.text :description
      t.string :speaker, limit: 75
      t.integer :total_rating
      t.decimal :member_cost, precision: 5, scale: 2
      t.decimal :guest_cost,  precision: 5, scale: 2
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :coffee_break
      t.attachment :poster

      t.references :activity,   index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
