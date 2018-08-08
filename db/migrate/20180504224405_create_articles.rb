class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :name, limit: 75
      t.text :text

      t.attachment :poster

      t.timestamps null: false
    end
  end
end
