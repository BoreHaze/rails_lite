module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      self.res.status = 302
      self.res.header['location'] = url
      self.render_content(nil, nil)
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      self.res.content_type = content_type
      raise RuntimeError if already_built_response?
      self.res.body = content
      @already_built_response = true
    end
  end
end
