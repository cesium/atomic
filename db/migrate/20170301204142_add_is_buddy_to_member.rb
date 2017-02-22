class AddIsBuddyToMember < ActiveRecord::Migration
  def change
    add_column :members, :is_buddy, :boolean, defaul: false
  end
end
