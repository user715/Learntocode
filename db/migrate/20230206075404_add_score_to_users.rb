class AddScoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :score, :int
  end
end
