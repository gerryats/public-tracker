class AddColumnCompanyTable < ActiveRecord::Migration
  def change
    add_column :companies, :owner_email_id, :string
  end
end
