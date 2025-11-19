# spec/requests/email_templates_spec.rb
require 'rails_helper'

RSpec.describe "EmailTemplatesController", type: :request do
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
      subject: "Hello {Contact.name}",
      body: "Body with {Contact.name} and {Portfolio.best_performance}%"
    )
  end

  describe "GET /email_templates" do
    it "returns a successful response and lists templates" do
      get email_templates_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(template.subject)
    end
  end

  describe "GET /email_templates/new" do
    it "renders the new template form" do
      get new_email_template_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /email_templates" do
    it "creates a new template successfully" do
      post email_templates_path, params: { email_template: { subject: "New Subject", body: "Valid body content." } }
      expect(response).to redirect_to(email_templates_path)
      follow_redirect!
      expect(response.body).to include("Template created successfully")
    end

    it "fails to create template with invalid data" do
      post email_templates_path, params: { email_template: { subject: "", body: "short" } }
      expect(response.body).to include("can't be blank").or include("is too short")
    end
  end

  describe "GET /email_templates/:id/edit" do
    it "renders the edit form" do
      get edit_email_template_path(template)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /email_templates/:id" do
    it "updates the template successfully" do
      patch email_template_path(template), params: { email_template: { subject: "Updated Subject" } }
      expect(response).to redirect_to(email_templates_path)
      follow_redirect!
      expect(response.body).to include("Template updated successfully")
      expect(template.reload.subject).to eq("Updated Subject")
    end

    it "fails to update with invalid data" do
      patch email_template_path(template), params: { email_template: { body: "short" } }
      expect(response.body).to include("is too short")
    end
  end

  describe "DELETE /email_templates/:id" do
    it "deletes the template" do
      delete email_template_path(template)
      expect(response).to redirect_to(email_templates_path)
      follow_redirect!
      expect(response.body).to include("Template deleted successfully")
      expect { template.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /email_templates/:id (show)" do
    it "renders template preview using dummy contact" do
      get email_template_path(template)
      expect(response).to have_http_status(:ok)
      # Should include contact name and best portfolio performance
      expect(response.body).to include(contact.name)
      expect(response.body).to include(contact.best_portfolio.performance.to_s)
    end
  end
end
