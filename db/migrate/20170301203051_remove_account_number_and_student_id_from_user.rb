class RemoveAccountNumberAndStudentIdFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :account_number
    remove_column :users, :student_id
  end
end
