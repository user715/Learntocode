class AddNameToLanguages < ActiveRecord::Migration[6.0]
  def change
    add_column :languages, :name, :string
  end
end
