class CreateTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :terms do |t|

      t.timestamps null: false
    end

    add_reference :terms, :board, index: true
    add_reference :terms, :department, index: true
    add_reference :terms, :role, index: true
    add_reference :terms, :user, index: true
  end
end
