require 'json'
require 'webrick'

class Flash

  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app_flash"
        @flash_hash = JSON.parse(cookie.value)
        now_hash = {}
        @flash_hash.each do |k, v|
          next if k == "now"
          @flash_hash.delete(k)
          now_hash[k] = v
        end

        @flash_hash["now"] = now_hash
        return
      end
    end

    @flash_hash = Hash.new
    nil
  end

  def now(key, val)
    @flash["now"] = {} if @flash["now"].nil?
    @flash["now"][key] = val
  end

  def now
    @flash_hash["now"]
  end

  def [](key)
    @flash_hash[key]
  end

  def []=(key, val)
    @flash_hash[key] = val
  end


  def store_flash(res)

    res.cookies << WEBrick::Cookie.new("_rails_lite_app_flash", @flash_hash.to_json)
  end

end
