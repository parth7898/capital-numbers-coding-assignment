# spec/models/contact_spec.rb
require 'rails_helper'

RSpec.describe Contact, type: :model do
  let!(:organization) { Organization.create!(name: "Test Org", email: "org@example.com") }

  describe "validations" do
    it "validates presence of name" do
      contact = Contact.new(name: nil, email: "test@example.com", organization: organization)
      expect(contact.valid?).to be false
      expect(contact.errors[:name]).to include("can't be blank")
    end

    it "validates presence of email" do
      contact = Contact.new(name: "John", email: nil, organization: organization)
      expect(contact.valid?).to be false
      expect(contact.errors[:email]).to include("can't be blank")
    end

    it "validates format of email" do
      contact = Contact.new(name: "John", email: "invalid_email", organization: organization)
      expect(contact.valid?).to be false
      expect(contact.errors[:email]).to include("is not a valid email")
    end

    it "validates uniqueness of email (case insensitive)" do
      Contact.create!(name: "John", email: "unique@example.com", organization: organization)
      duplicate = Contact.new(name: "Jane", email: "UNIQUE@example.com", organization: organization)
      expect(duplicate.valid?).to be false
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "is valid with proper name and email" do
      contact = Contact.new(name: "John", email: "john@example.com", organization: organization)
      expect(contact.valid?).to be true
    end
  end

  describe "associations" do
    it "has many portfolios" do
      contact = Contact.create!(name: "John", email: "john#{rand(1000)}@example.com", organization: organization)
      portfolio = Portfolio.create!(name: "Portfolio A", balance: 1000, performance: 50, contact: contact)
      expect(contact.portfolios).to include(portfolio)
    end
  end

  describe "#best_portfolio and #worst_portfolio" do
    it "returns the portfolio with highest and lowest performance" do
      contact = Contact.create!(name: "John", email: "john#{rand(1000)}@example.com", organization: organization)
      p1 = Portfolio.create!(name: "Portfolio A", balance: 1000, performance: 50, contact: contact)
      p2 = Portfolio.create!(name: "Portfolio B", balance: 500, performance: 30, contact: contact)
      p3 = Portfolio.create!(name: "Portfolio C", balance: 2000, performance: 70, contact: contact)

      expect(contact.best_portfolio).to eq(p3)
      expect(contact.worst_portfolio).to eq(p2)
    end
  end
end
