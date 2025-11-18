class Contact < ApplicationRecord
  belongs_to :organization
  has_many :portfolios, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true

  def best_portfolio
    portfolios.order(performance: :desc).first
  end

  def worst_portfolio
    portfolios.order(performance: :asc).first
  end

end
