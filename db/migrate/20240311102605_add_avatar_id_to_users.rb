class AddAvatarIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :avatar, null: true, foreign_key: true
  end
end
