class CreateSolvedProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :solved_problems do |t|
      t.integer :user_id
      t.integer :problem_id
    end
  end
end
