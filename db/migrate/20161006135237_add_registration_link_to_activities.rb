class AddRegistrationLinkToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :registration_link, :string
  end
end
