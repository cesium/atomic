class AddIsBuddyToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :is_buddy, :boolean, defaul: false
  end
end
