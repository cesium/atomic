class AddConfirmedToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :confirmed, :boolean, default: false
  end
end
