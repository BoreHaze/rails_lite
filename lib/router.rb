class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name, :router

  def initialize(pattern, http_method, controller_class, action_name, router)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name

    @router = router
  end

  def matches?(req)
    req.path.match(pattern) &&
    req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
    route_matches = pattern.match(req.path)
    route_params = {}
    route_matches.names.each do |k|
      next if route_matches[k].nil?
      route_params[k] = route_matches[k]
    end

    controller_class.new(req, res, route_params, router.routes).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name, self)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      self.add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    route = self.match(req)
    if route.nil?
      res.status = 404
    else
      route.run(req, res)
    end
  end
end
