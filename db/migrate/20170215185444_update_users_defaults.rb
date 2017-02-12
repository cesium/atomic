class UpdateUsersDefaults < ActiveRecord::Migration
  def change
    change_column_default :users, :phone_number, ""
    change_column_default :users, :account_number, ""
  end
end
