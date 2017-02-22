class RemovePhoneFromMember < ActiveRecord::Migration
  def change
    remove_column :members, :phone
  end
end
