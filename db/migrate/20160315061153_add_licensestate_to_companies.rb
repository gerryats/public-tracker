class AddLicensestateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :License_state, :string, :default => 'deactivate'
  end
end
