class Job < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :keywords
  belongs_to :contract
end
