class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false}

  has_many :problem_categories
  has_many :problems, through: :problem_categories, dependent: :destroy

end