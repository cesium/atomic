class RemovePhoneFromMember < ActiveRecord::Migration[4.2]
  def change
    remove_column :members, :phone
  end
end
