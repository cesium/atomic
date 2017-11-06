class RenameTables < ActiveRecord::Migration[5.1]
  def change
    rename_table :users, :identifiers
    remove_column :identifiers, :member_id 
    remove_column :registrations, :user_id

    rename_table :members, :users
    add_reference :identifiers, :users 
    add_reference :registrations, :users
  end
end
