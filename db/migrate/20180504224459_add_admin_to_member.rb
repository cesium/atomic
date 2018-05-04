class AddAdminToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :admin, :boolean, default: false, null: false
  end
end
