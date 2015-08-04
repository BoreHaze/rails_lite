## Rails Lite

  A Ruby HTTP server implementing a subset of features found in Ruby on Rails. Features include:

  - Dynamic route generation using Ruby's metaprogramming capabilities to implement a routing DSL.
  - Parses HTTP request parameters from three conventional sources that Rails uses: URI route params, query string params, and wrapped body params.
  - Parses and renders ERB templates.
  - Maintains session persistence with session tokens.
  - Enables persistence through redirects via Flash-cookie storage.
  - Implements basic CSRF protection through unique authenticity tokens for each request-response cycle.
  - Provides Rails-like helper methods to reference generated routes from within application code, and from within ERB templates.

  To use Rails Lite (which is highly inadvisable at present), you simply need to define a controller and your set of desired routes, in a manner similar to the more verbose version of the Rails convention, then start a Webrick instance with a block invoking the router's run method. Here's an example:

  ```ruby
  class CatsController < Controller
    def index
      render_content(cats_index_template, "text/text")
    end
  end

  router = Router.new
  router.draw do
    get Regexp.new("^/cats$"), CatsController, :index
  end


  server = WEBrick::HTTPServer.new(Port: 3000)
  server.mount_proc('/') do |req, res|
    route = router.run(req, res)
  end
  ```
