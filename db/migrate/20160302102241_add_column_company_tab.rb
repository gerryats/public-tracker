class AddColumnCompanyTab < ActiveRecord::Migration
  def change
    add_column :companies, :validity, :integer
  end
end
