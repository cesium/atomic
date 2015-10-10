class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.references  :user,  foreign_key: true
      t.references  :role,  foreign_key: true
      t.references  :board, foreign_key: true

      t.timestamps  null: false
    end
  end
end
