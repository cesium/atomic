class RemoveRegistrationLinkFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :registration_link
  end
end
