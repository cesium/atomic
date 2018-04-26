class DropUnusedData < ActiveRecord::Migration[5.1]
  def change
    remove_column :activities, :department_id

    drop_table :terms
    drop_table :boards
    drop_table :departments
    drop_table :payments
    drop_table :roles
  end
end
