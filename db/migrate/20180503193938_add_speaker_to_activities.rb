class AddSpeakerToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :speaker, :string, limit: 75
  end
end
