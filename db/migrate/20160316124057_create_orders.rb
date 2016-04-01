class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :new
      t.integer :cart_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires

      t.timestamps null: false
    end
  end
end
