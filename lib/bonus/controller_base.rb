require_relative '../phase6/controller_base'
require_relative './route_helper'
require_relative './view_helper'
require_relative './flash'

class ControllerBase < Phase6::ControllerBase
  include RouteHelper

  def initialize(req, res, route_params = {}, routes)
    @flash = Flash.new(req)
    define_route_helpers(routes)
    super(req, res, route_params)
  end
end
