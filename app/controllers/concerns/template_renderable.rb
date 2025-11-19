module TemplateRenderable
  extend ActiveSupport::Concern

  def render_template_for(contact, template)
    renderer = TemplateRenderer.new(template, contact)
    {
      subject: renderer.render_subject,
      body: renderer.render_body
    }
  end

  def render_preview_partial(rendered)
    render(
      template: "shared/email_preview",
      locals: {
        subject: rendered[:subject],
        body: rendered[:body]
      }
    )
  end


end
