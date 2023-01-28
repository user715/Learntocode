class Problem < ApplicationRecord

  has_many :user_problem_likes
  has_many :liked_users, through: :user_problem_likes, source: :user, dependent: :destroy

  has_many :solved_problems
  has_many :solved_users, through: :solved_problems, source: :user, dependent: :destroy

  has_many :problem_categories
  has_many :categories, through: :problem_categories, dependent: :destroy

  belongs_to :tag

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :test_cases, presence: true
  validates :sample_cases, presence: true
  validates :test_case_solutions, presence: true
  validates :sample_case_solutions, presence: true
  validates :tag_id, presence: true
end