class AddActivityAdminToMember < ActiveRecord::Migration
  def change
    add_column :members, :activity_admin, :boolean, default: false, null: false
  end
end
