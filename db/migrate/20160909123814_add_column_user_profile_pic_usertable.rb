class AddColumnUserProfilePicUsertable < ActiveRecord::Migration
  def change
  	add_column :users, :user_profile_pic, :string
  end
end
