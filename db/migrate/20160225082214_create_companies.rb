class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :user_id
      t.string :company_name
      t.string :trade_show_name

      t.timestamps null: false
    end
  end
end
