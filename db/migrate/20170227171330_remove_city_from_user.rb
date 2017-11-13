class RemoveCityFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :city
  end
end
