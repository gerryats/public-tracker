class AddNewColumnUsertable < ActiveRecord::Migration
  def change
    remove_column :users, :username
    remove_column :users, :company_id
    add_column :users, :owner_email_id, :string
  end
end
