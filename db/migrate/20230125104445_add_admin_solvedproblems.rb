class AddAdminSolvedproblems < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :easysolved, :int, default: 0
    add_column :users, :mediumSolved, :int, default: 0
    add_column :users, :difficultSolved, :int, default: 0
  end
end
