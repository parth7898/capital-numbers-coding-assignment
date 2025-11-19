class TemplateRenderer
  TOKEN_REGEX = /\{([^\}]+)\}/

  def initialize(template, contact)
    @template = template
    @contact = contact
  end

  def render_subject
    replace(@template.subject.to_s)
  end

  def render_body
    replace(@template.body.to_s)
  end

  private

  def replace(text)
    text.gsub(TOKEN_REGEX) do |match|
      token = $1.strip
      case token
      when 'Contact.name' then @contact&.name.to_s
      when 'Contact.email' then @contact&.email.to_s
      when 'Organization.name' then @contact&.organization&.name.to_s
      when 'Organization.email' then @contact&.organization&.email.to_s
      when 'Portfolio.best_performance'
        perf = @contact&.best_portfolio&.performance
        perf ? "#{perf}%" : "N/A"
      when 'Portfolio.worst_performance'
        perf = @contact&.worst_portfolio&.performance
        perf ? "#{perf}%" : "N/A"
      else
        match 
      end
    end
  end
end
