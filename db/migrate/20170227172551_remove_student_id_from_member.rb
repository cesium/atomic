class RemoveStudentIdFromMember < ActiveRecord::Migration[4.2]
  def change
    remove_column :members, :student_id
  end
end
