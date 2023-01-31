class CreateSubmission < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.text :script
      t.string :language
      t.integer :versionIndex
      t.integer :user_id
      t.integer :problem_id
    end
  end
end
