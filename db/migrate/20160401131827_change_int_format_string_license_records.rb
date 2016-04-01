class ChangeIntFormatStringLicenseRecords < ActiveRecord::Migration
  def up
    change_column :license_records, :license, :string
  end

  def down
    change_column :license_records, :license, :integer
  end
end
