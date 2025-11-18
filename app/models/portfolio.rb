class Portfolio < ApplicationRecord
  belongs_to :contact
  validates :name, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :performance, numericality: true
end
