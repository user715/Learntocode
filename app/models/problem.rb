class Problem < ApplicationRecord
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :test_cases, presence: true
  validates :sample_cases, presence: true
  validates :test_case_solutions, presence: true
  validates :sample_case_solutions, presence: true
  validates :tag_id, presence: true
end