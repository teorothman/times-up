class AddIsReadyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_ready, :boolean, default: false
  end
end
