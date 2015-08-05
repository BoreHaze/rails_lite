require 'json'
require 'webrick'

class Session

  def initialize(req)

    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @cookie_hash = JSON.parse(cookie.value)
        return
      end
    end

    @cookie_hash = Hash.new
    nil
  end

  def [](key)
    @cookie_hash[key]
  end

  def []=(key, val)
    @cookie_hash[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie_hash.to_json)
  end
end
