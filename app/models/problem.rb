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

  def self.execute(script,language,versionIndex,testcases)
    require "http"
    response = HTTP.post("https://api.jdoodle.com/v1/execute",
       :json => { 
        "clientId": "5ee319cd11aa78cedfcb56cd7efbbfdf",
        "clientSecret": "bdd162bf4659f1b00bd8ce508ebccdec5d9c08b986fccff22df9a06f2df51d99",
        "script": script,
        "language": language,
        "versionIndex": versionIndex,
        "stdin": testcases
    })
    object = JSON.parse(response.body, symbolize_names: true)
  end

end