class AddIsadminToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :isadmin, :integer, :default => 0
  end
end
