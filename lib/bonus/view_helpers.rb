module ViewHelper
  def link_to(name, url)

    link_url = "localhost:3000/#{url}"
    #Check that route is valid? Need access to router from controller?

    <<-HTML.html_safe
      <a href=#{link_url}>#{name}</a>
    HTML
  end

  def button_to(post_path)

  end
end
