class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :date
      t.decimal :value, precision: 8, scale: 2
      t.references :user

      t.timestamps null: false
    end
  end
end
