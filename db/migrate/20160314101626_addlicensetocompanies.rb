class Addlicensetocompanies < ActiveRecord::Migration
  def change
    add_column :companies, :license, :string
  end
end
