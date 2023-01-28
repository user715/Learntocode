class Tag < ApplicationRecord

  has_many :problems, dependent: :destroy

  validates :tagname, presence: true, uniqueness: { case_sensitive: false }
end