require 'webrick'
require 'byebug'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/authenticity_token'

describe AuthenticityToken do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:token){ "v5HQ7Iely1bSzkBLem0sSDyhb8NFGp-yeC-gD_eeiZSNUikR9bqk3JBvNg7jFLXDn1QnjObuMvwUOpSs4fV3tQ" }
  let(:cook) { WEBrick::Cookie.new('authenticity_token', token.to_json) }
  let(:router) { Router.new }

  before(:all) do
    class Ctrlr < ControllerBase
      def index
      end

      def render
      end
    end
  end
  after(:all) { Object.send(:remove_const, "Ctrlr") }

  it "Sets an authenticity token cookie on each request" do

    route = Route.new(Regexp.new("^/statuses/(?<id>\\d+)$"), :get, Ctrlr, :index, router)
    allow(req).to receive(:path) { "/statuses/1" }
    allow(req).to receive(:request_method) { :get }
    route.run(req, res)

    auth_cookie = res.cookies.find {|c| c.name == 'authenticity_token'}
    expect(auth_cookie).not_to be(nil)
    expect(auth_cookie.value).not_to be(nil)

  end
end
