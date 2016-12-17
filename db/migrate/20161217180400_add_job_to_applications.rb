class AddJobToApplications < ActiveRecord::Migration[5.0]
  def change
    add_reference :applications, :job, foreign_key: true
  end
end
