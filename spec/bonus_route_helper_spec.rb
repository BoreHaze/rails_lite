require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require 'byebug'

describe ControllerBase do
  before (:all) do
    class CatzController < ControllerBase
      def index
      end
      def show
      end
      def new
      end
      def create
      end
      def edit
      end
      def update
      end
    end

    class Cat
      def id
        37
      end
    end
  end

  let(:router) do
    router = Router.new
    router.draw do
      get Regexp.new("^/catz$"), CatzController, :index
      get Regexp.new("^/catz/\\d+$"), CatzController, :show
      get Regexp.new("^/catz/new$"), CatzController, :new
      post Regexp.new("^/catz$"), CatzController, :create
      get Regexp.new("^/catz/\\d+/edit$"), CatzController, :edit
      put Regexp.new("^/catz/\\d+$"), CatzController, :update
    end

    router
  end

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cat) { Cat.new }

  it "Defines route helpers on initialization" do
    controller = CatzController.new(req, res, {}, router.routes)
    expect(controller).to respond_to(:catz_url)
    expect(controller).to respond_to(:new_catz_url)
    expect(controller).to respond_to(:edit_catz_url)
  end


  it "Route helpers generate urls that match non-parametrized routes" do
    controller = CatzController.new(req, res, {}, router.routes)
    route = controller.catz_url
    expect(route).to eq("/catz")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:index)
  end

  it "Route helpers generate urls that match parametrized routes" do
    controller = CatzController.new(req, res, {}, router.routes)
    route = controller.catz_url(cat)
    expect(route).to eq("/catz/37")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:show)
  end

  it "Route helpers generate urls that match parametrized, verb postpended routes" do
    controller = CatzController.new(req, res, {}, router.routes)
    route = controller.edit_catz_url(cat)
    expect(route).to eq("/catz/37/edit")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:edit)
  end

  it "Route matches correctly to HTTP method" do
    controller = CatzController.new(req, res, {}, router.routes)
    route = controller.catz_url(cat)
    expect(route).to eq("/catz/37")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("PUT")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:update)
  end

end
