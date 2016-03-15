class CreateTradeshows < ActiveRecord::Migration
  def change
    create_table :tradeshows do |t|
      t.string :trade_show_name
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
