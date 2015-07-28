## Rails Lite

  A Ruby HTTP server implementing a subset of features found in Ruby on Rails. Features include:

  - Dynamic route generation using Ruby's metaprogramming capabilities to implement a routing DSL.
  - Parses HTTP request parameters from three conventional sources that Rails uses: URI route params, query string params, and wrapped body params.
  - Parses and renders ERB templates.
  - Maintains session persistence with session tokens.
  - Enables persistence through redirects via Flash-cookie storage.
  - Implements basic CSRF protection through unique authenticity tokens for each request-response cycle.
  - Provides Rails-like helper methods to reference generated routes from within application code, and from within ERB templates.
