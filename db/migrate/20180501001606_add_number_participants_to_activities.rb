class AddNumberParticipantsToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :number_participants, :integer
  end
end
