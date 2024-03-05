class CreateAvatars < ActiveRecord::Migration[7.1]
  def change
    create_table :avatars do |t|

      t.timestamps
    end
  end
end
