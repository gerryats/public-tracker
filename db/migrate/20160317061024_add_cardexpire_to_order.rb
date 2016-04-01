class AddCardexpireToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :card_expires_on, :date
  end
end
