class AddTotalCostAndTotalDaysToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_cost ,:integer
    add_column :orders, :total_days ,:integer
  end
end
