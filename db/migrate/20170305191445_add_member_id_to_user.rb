class AddMemberIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :member, foreign_key: true
  end
end
