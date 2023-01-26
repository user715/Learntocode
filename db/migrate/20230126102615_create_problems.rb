class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :description
      t.text :test_cases
      t.text :test_case_solutions
      t.text :sample_cases
      t.text :sample_case_solutions
      t.integer :likes, default: 0
      t.integer :tag_id
    end
  end
end
