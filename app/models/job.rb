class Job < ApplicationRecord
  belongs_to :category, optional: true
  has_and_belongs_to_many :keywords, optional: true
  belongs_to :contract, optional: true
  has_many :applications

  accepts_nested_attributes_for :keywords
end
