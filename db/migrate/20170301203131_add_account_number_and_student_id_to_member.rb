class AddAccountNumberAndStudentIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :account_number, :string, default: ""
    add_column :members, :student_id, :string, default: ""
  end
end
