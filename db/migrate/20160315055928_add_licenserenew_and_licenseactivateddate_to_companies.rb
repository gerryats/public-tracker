class AddLicenserenewAndLicenseactivateddateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :License_activation_date, :datetime
    add_column :companies, :License_renewed_date, :datetime
    add_column :companies, :License_valid_days, :integer
  end
end
