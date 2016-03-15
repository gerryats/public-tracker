class CreateValidlicenses < ActiveRecord::Migration
  def change
    create_table :validlicenses do |t|
      t.integer :generated_licenses

      t.timestamps null: false
    end
  end
end
