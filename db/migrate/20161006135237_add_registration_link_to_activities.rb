class AddRegistrationLinkToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :registration_link, :string
  end
end
