class RemoveAccountNumberAndStudentIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :account_number
    remove_column :users, :student_id
  end
end
