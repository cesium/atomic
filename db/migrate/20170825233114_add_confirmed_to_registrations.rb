class AddConfirmedToRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :confirmed, :boolean, default: false
  end
end
