class DeleteColumnFromComapnies < ActiveRecord::Migration
  def change
    remove_column :companies, :validity
  end
end
