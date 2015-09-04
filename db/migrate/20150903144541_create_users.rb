class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_number, limit: 10
      t.string :student_id, limit: 10
      t.string :name, limit: 75
      t.string :street, limit: 100
      t.string :city, limit: 20
      t.string :phone_number, limit: 10
      t.date :birthdate

      t.string :type

      t.timestamps null: false
    end

    add_index :users, :account_number, unique: true
    add_index :users, :student_id, unique: true
  end
end
