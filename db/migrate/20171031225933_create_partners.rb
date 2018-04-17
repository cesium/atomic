class CreatePartners < ActiveRecord::Migration[4.2]
  def change
    create_table :partners do |t|
      t.string :name, limit: 75
      t.string :description
      t.attachment :logo
      t.string :link

      t.timestamps null: false
    end
  end
end
