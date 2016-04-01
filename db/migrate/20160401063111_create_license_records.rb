class CreateLicenseRecords < ActiveRecord::Migration
  def change
    create_table :license_records do |t|
      t.string :email
      t.integer :license
      t.integer :cost

      t.timestamps null: false
    end
  end
end
