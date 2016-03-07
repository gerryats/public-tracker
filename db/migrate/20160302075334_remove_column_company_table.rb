class RemoveColumnCompanyTable < ActiveRecord::Migration
  def change
    remove_column :companies, :owner_name
  end
end
