class AddTradeshowidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trade_show_id, :integer
  end
end
