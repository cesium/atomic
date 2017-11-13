class CreateBoards < ActiveRecord::Migration[4.2]
  def change
    create_table :boards do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
