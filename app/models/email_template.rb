class EmailTemplate < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }
end
