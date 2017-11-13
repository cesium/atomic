class RemoveNameFromMember < ActiveRecord::Migration[4.2]
  def change
    remove_column :members, :name
  end
end
