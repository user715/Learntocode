class CreateUserProblemLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_problem_likes do |t|
      t.integer :user_id
      t.integer :problem_id
    end
  end
end
