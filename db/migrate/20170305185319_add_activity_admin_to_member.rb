class AddActivityAdminToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :activity_admin, :boolean, default: false, null: false
  end
end
