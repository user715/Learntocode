class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :language
      t.string :versionIndex
    end
  end
end
