class CreateJobsAndKeywords < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs_keywords do |t|
      t.belongs_to :job, index: true
      t.belongs_to :keyword, index: true
    end
  end
end
