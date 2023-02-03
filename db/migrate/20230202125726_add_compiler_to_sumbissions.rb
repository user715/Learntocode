class AddCompilerToSumbissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :compiler, :string
  end
end
