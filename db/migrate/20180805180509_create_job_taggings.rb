class CreateJobTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :job_taggings do |t|
      t.belongs_to :job, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
  end
end
