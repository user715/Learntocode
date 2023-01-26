class Tag < ApplicationRecord
  validates :tagname, presence: true, uniqueness: { case_sensitive: false }
end