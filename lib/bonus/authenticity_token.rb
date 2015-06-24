require 'SecureRandom'

module AuthTokenGetter

  def old_token
    @old_token ||= get_old_token(@req)
  end

  def get_old_token(req)
    prior_token_cookie = req.cookies.find { |c| c.name == "authenticity_token"}
    if prior_token_cookie.nil?
      nil
    else
      JSON.parse(prior_token_cookie.value)
    end
  end

  def check_form_auth_token(token)
    token == old_token
  end
end

module AuthTokenSetter

  def generate_auth_token
    SecureRandom::urlsafe_base64(64)
  end

  def set_response_token(res)
    res.cookies << WEBrick::Cookie.new("authenticity_token", new_token.to_json)
  end

  def form_auth_token
    new_token
  end

  def new_token
    @new_token ||= generate_auth_token
  end
end
