require 'uri'

class Params

  def initialize(req, route_params = {})
    @params = route_params
    parse_www_encoded_form(req.query_string) unless req.query_string.nil?
    parse_www_encoded_form(req.body) unless req.body.nil?
  end

  def [](key)
    val = @params[key.to_s]
    val ||= @params[key.to_sym]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  def parse_www_encoded_form(www_encoded_form)
    params = URI::decode_www_form(www_encoded_form)
    params.each do |qp|
      k, v = qp
      if k.include?("[")
        keys = parse_key(k)
        top_level_key = keys.shift
        next_key = top_level_key
        traverse_hash = @params
        while !keys.empty?
          if traverse_hash[next_key] == nil
            traverse_hash[next_key] = Hash.new
          end
          traverse_hash = traverse_hash[next_key]
          next_key = keys.shift
        end
        traverse_hash[next_key] = v
      else
        @params[k] = v
      end
    end

    nil
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
