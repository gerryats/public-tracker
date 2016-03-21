class AddEmailColumnTovalidliceses < ActiveRecord::Migration
  def change
    add_column :validlicenses, :owner_email ,:string
  end
end
