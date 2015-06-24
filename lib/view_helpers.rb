require 'erb'

module ViewHelper

  def link_to(name, url)

    link_url = "#{url}"
    #Check that route is valid? Need access to router from controller?

    <<-HTML
<a href=#{link_url}>#{name}</a>
    HTML
  end

  def button_to(name, url, method = nil)

    if %w(delete put patch).include?(method.downcase)
      hidden_method = <<-HTML
<input type='hidden' name='_method' value='#{method}'>
      HTML
    end

    <<-HTML
<form action='#{url}' method='POST'>
  #{hidden_method unless hidden_method.nil?}
  <input value='#{name}' type='submit'>
</form>
    HTML
  end
end
