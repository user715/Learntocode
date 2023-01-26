class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tagname
      t.integer :problem_count, default: 0
    end
  end
end
