require 'json'
require 'webrick'

class Flash

  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app_flash"
        @flash_hash = JSON.parse(cookie.value)
        now_hash = {}
        expiring = {}
        @flash_hash.each do |k, v|
          if k == "now"
            v.each do |nk, nv|
              expiring[nk] = nv
            end
          else
            @flash_hash.delete(k)
            now_hash[k] = v
          end
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
    @flash_hash["now"] || @flash_hash["now"] = {}
  end

  def now=(hash)
    now = self.now
    hash.each do |k,v|
      now[k] = v
    end
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
