class RemoveRegistrationLinkFromActivity < ActiveRecord::Migration[4.2]
  def change
    remove_column :activities, :registration_link
  end
end
