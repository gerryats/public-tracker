class AddCostToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :cost ,:integer
  end
end
