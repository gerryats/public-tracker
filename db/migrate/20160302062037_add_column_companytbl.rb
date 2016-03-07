class AddColumnCompanytbl < ActiveRecord::Migration
  def change
    add_column :companies, :comment, :string
    add_column :companies, :owner_name, :string
  end
end
