require_relative '../phase6/controller_base'
require_relative './route_helper'
require_relative './view_helpers'
# require_relative './flash'
require_relative './authenticity_token'

class ControllerBase < Phase6::ControllerBase
  include RouteHelper
  include ViewHelper

  def initialize(req, res, route_params = {}, routes)
    define_route_helpers(routes)
    super(req, res, route_params)
  end

end
