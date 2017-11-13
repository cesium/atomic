class AddMemberIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :member, foreign_key: true
  end
end
