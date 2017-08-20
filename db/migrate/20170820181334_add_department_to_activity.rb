class AddDepartmentToActivity < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.references :department, index: true, foreign_key: true
    end
  end
end
