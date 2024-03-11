class AddTitleToRules < ActiveRecord::Migration[7.1]
  def change
    add_column :rules, :title, :string
  end
end
