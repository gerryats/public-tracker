class RemoveColumnCompanytable < ActiveRecord::Migration
  def change
    remove_column :companies, :user_id
  end
end
