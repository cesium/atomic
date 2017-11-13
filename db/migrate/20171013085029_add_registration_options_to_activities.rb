class AddRegistrationOptionsToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :allows_registrations, :boolean, default: true
    add_column :activities, :external_link, :string, default: ""
  end
end
