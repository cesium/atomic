class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|

      t.timestamps null: false
    end

    add_reference :terms, :board, index: true
    add_reference :terms, :department, index: true
    add_reference :terms, :role, index: true
  end
end
