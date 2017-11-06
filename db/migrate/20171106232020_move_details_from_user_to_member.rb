class MoveDetailsFromUserToMember < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :name
    remove_column :users, :phone_number
    remove_column :users, :email
    remove_column :users, :type
    remove_column :users, :image

    remove_column :members, :address
    remove_column :members, :birthdate
    remove_column :members, :member_id
    remove_column :members, :paid
    remove_column :members, :is_buddy

    add_column :members, :phone_number, :string, limit: 15, default: ""
    add_column :members, :name, :string, limit: 75, null: false
    add_column :members, :hashname, :string, null: false
    add_column :members, :image, :string
    change_column_null :members, :email, false
    rename_column :members, :account_number, :cesium_id
  end
end
