require_relative '../phase3/controller_base'
# require_relative './session'
require_relative '../bonus/flash'

module Phase4
  class ControllerBase < Phase3::ControllerBase

    def redirect_to(url)
      flash.store_flash(self.res)
      super(url)
    end

    def render_content(content, content_type)
      flash.store_flash(self.res)
      super(content, content_type)
    end

    # method exposing a `Session` object
    def flash
      @flash ||= Flash.new(self.req)
    end
  end
end
