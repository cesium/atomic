class RemoveStudentIdFromMember < ActiveRecord::Migration
  def change
    remove_column :members, :student_id
  end
end
