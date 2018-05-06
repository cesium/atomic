class AddLimiteNumberParticipantsToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :limit_number_participants, :boolean
  end
end
