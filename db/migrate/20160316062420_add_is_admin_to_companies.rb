class AddIsAdminToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :is_admin, :integer, :default => 0
  end
end
