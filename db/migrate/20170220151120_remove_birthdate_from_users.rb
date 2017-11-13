class RemoveBirthdateFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :birthdate
  end
end
