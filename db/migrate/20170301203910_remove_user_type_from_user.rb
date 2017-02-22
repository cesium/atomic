class RemoveUserTypeFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :user_type
  end
end
