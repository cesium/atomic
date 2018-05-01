class RenameTables < ActiveRecord::Migration[5.1]
  def change
    rename_table :users, :identities
    remove_column :identities, :member_id 
    remove_column :registrations, :user_id

    rename_table :members, :users
    add_reference :identities, :user
    add_reference :registrations, :user
  end
end
