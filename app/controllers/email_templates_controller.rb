class EmailTemplatesController < ApplicationController
  include TemplateRenderable

  before_action :set_template, only: [:show, :edit, :update, :destroy, :preview]
  before_action :set_contact,  only: [:preview] 

  def index
    @email_templates = EmailTemplate.order(created_at: :desc)
  end

  def new
    @email_template = EmailTemplate.new
  end

  def create
    @email_template = EmailTemplate.new(template_params)
    if @email_template.save
     redirect_to email_templates_path, flash: { success: "Template created successfully" }
    else
      render :new
    end
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
  end

  def update
    @email_template = EmailTemplate.find(params[:id])
    if @email_template.update(template_params)
      redirect_to email_templates_path, flash: { success: "Template updated successfully" }
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @template.destroy
    redirect_to email_templates_path, flash: { success: "Template deleted successfully"}
  end

  def preview
    render_template_preview
  end

  private

  def set_template
    @template = EmailTemplate.find(params[:id])
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def template_params
    params.require(:email_template).permit(:subject, :body)
  end

  def render_template_preview
    rendered = render_template_for(@contact, @template)
    render_preview_partial(rendered)
  end
  
end
