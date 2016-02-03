class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: true, limit: 60
  end
end
