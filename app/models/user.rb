class User < ApplicationRecord

  has_many :user_problem_likes
  has_many :liked_problems, through: :user_problem_likes, source: :problem, dependent: :destroy

  has_many :solved_problems
  has_many :problems_solved, through: :solved_problems, source: :problem, dependent: :destroy

  has_many :submissions, dependent: :destroy

  before_save { self.email = email.downcase }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 105 }, format: {with: VALID_EMAIL_REGEX }
  has_secure_password
  # validates :password, presence: true, length: { minimum: 4 }
end