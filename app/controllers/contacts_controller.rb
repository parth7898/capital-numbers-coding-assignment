class ContactsController < ApplicationController
    include TemplateRenderable
     before_action :set_contact, :set_template, only: [:preview_email, :send_email]
     
    def index
      @contacts = Contact.includes(:organization, :portfolios).all
      @email_templates = EmailTemplate.all
    end

    def preview_email
      rendered = render_template_for(@contact, @template)
      render_preview_partial(rendered)
    end

    def send_email
      rendered = render_template_for(@contact, @template)
      Rails.logger.info "Sending email to #{@contact.email} with subject: #{rendered[:subject]}"
      flash[:success] = "Email sent successfully to #{@contact.email}"
      redirect_to contacts_path
    end
    
    
    private

    def set_contact
      @contact = Contact.find(params[:id])
    end
    
    def set_template
        @template = EmailTemplate.find_by(id: params[:template_id])
    end
end
