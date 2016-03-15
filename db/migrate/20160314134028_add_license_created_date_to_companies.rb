class AddLicenseCreatedDateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :License_creation_date, :datetime
  end
end
