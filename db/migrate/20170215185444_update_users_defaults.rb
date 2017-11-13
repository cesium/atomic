class UpdateUsersDefaults < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :phone_number, ""
    change_column_default :users, :account_number, ""
  end
end
