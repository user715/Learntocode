class UserProblemLike < ApplicationRecord
  belongs_to :user
  belongs_to :problem
end