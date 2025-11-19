require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do
  include TemplateRenderable

  let!(:organization) { Organization.create!(name: "Org 1", email: "org1@example.com") }
  let!(:contact) do 
    Contact.create!(
      name: "John Doe",
      email: "john.doe#{rand(1000)}@example.com",
      organization: organization
    )
  end
  let!(:portfolio) do
    Portfolio.create!(
      name: "Portfolio 1",
      balance: 1000.0,
      performance: 12.5,
      contact: contact
    )
  end
  let!(:template) do
    EmailTemplate.create!(
      subject: "Quarterly Report for {Contact.name}",
      body: "Hello {Contact.name}, your portfolio performance: Best: {Portfolio.best_performance}% Worst: {Portfolio.worst_performance}%"
    )
  end

  describe "validations" do
    it "validates presence of subject" do
      t = EmailTemplate.new(subject: nil, body: "Valid body text longer than 10 chars")
      expect(t.valid?).to be false
      expect(t.errors[:subject]).to include("can't be blank")
    end

    it "validates length of subject (maximum 255 characters)" do
      long_subject = "a" * 256
      t = EmailTemplate.new(subject: long_subject, body: "Valid body text longer than 10 chars")
      expect(t.valid?).to be false
      expect(t.errors[:subject]).to include("is too long (maximum is 255 characters)")
    end

    it "validates presence of body" do
      t = EmailTemplate.new(subject: "Valid Subject", body: nil)
      expect(t.valid?).to be false
      expect(t.errors[:body]).to include("can't be blank")
    end

    it "validates length of body (minimum 10 characters)" do
      t = EmailTemplate.new(subject: "Valid Subject", body: "Too short")
      expect(t.valid?).to be false
      expect(t.errors[:body]).to include("is too short (minimum is 10 characters)")
    end

    it "is valid with proper subject and body" do
      t = EmailTemplate.new(subject: "Hello", body: "This is a valid body text.")
      expect(t.valid?).to be true
    end
  end

  describe "#shortcode_parsing via render_template_for" do
    it "replaces {Contact.name} in subject and body with contact name" do
      rendered = render_template_for(contact, template)
      expect(rendered[:subject]).to include(contact.name)
      expect(rendered[:body]).to include(contact.name)
    end

    it "replaces {Portfolio.best_performance} with best portfolio performance" do
      rendered = render_template_for(contact, template)
      expect(rendered[:body]).to include(contact.best_portfolio.performance.to_s)
    end

    it "replaces {Portfolio.worst_performance} with worst portfolio performance" do
      rendered = render_template_for(contact, template)
      expect(rendered[:body]).to include(contact.worst_portfolio.performance.to_s)
    end
  end
end
