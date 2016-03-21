class RenameCardTypeToCardBrand < ActiveRecord::Migration
  def change
    rename_column :orders, :card_type, :card_brand
  end
end
