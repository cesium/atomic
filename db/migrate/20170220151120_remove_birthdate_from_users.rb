class RemoveBirthdateFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :birthdate
  end
end
