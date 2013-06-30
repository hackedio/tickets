class AddIndexToGroups < ActiveRecord::Migration
  def change
    add_index :groups, :name
  end
end
