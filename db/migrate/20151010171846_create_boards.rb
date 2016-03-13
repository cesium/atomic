class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :year
      t.date :start

      t.timestamps null: false
    end
  end
end
