class AddContractToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :contract, foreign_key: true
  end
end
