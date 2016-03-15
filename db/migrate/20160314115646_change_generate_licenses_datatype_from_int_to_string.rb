class ChangeGenerateLicensesDatatypeFromIntToString < ActiveRecord::Migration
  def change
    change_column :validlicenses, :generated_licenses, :string
  end
end
