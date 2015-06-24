require 'active_support'
require 'active_support/core_ext'
require 'erb'

require_relative './route_helper'
require_relative './view_helpers'
require_relative './flash'
require_relative './params'
require_relative './session'
require_relative './authenticity_token'

class ControllerBase
  include RouteHelper
  include ViewHelper
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {}, routes = {})
    define_route_helpers(routes)
    @params = Params.new(req, route_params)
    @req = req
    @res = res
  end


  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    session.store_session(self.res)
    flash.store_flash(self.res)
    self.res.status = 302
    self.res.header['location'] = url
    self.render_content(nil, nil)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    session.store_session(self.res)
    flash.store_flash(self.res)
    self.res.content_type = content_type
    raise RuntimeError if already_built_response?
    self.res.body = content
    @already_built_response = true
  end

  def render(template_name)
    file_str = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    template = ERB.new(File.read(file_str))
    content = template.result(binding)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(self.req)
  end

  def flash
    @flash ||= Flash.new(self.req)
  end

  def invoke_action(name)
    self.send(name)
    render unless already_built_response?
  end

end
