class CreateMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :members do |t|
      t.integer :member_id
      t.string :name
      t.string :phone
      t.string :address
      t.string :email
      t.date :birthdate
      t.string :course
      t.string :student_id
      t.boolean :paid

      t.timestamps null: false
    end
  end
end
