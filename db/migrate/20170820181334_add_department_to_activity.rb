class AddDepartmentToActivity < ActiveRecord::Migration[4.2]
  def change
    change_table :activities do |t|
      t.references :department, index: true, foreign_key: true
    end
  end
end
