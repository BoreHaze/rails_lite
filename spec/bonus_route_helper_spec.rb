require 'webrick'
require_relative '../lib/bonus/controller_base'
require_relative '../lib/phase6/router'
require 'byebug'

describe ControllerBase do
  before (:all) do
    class CatsController < ControllerBase
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
    router = Phase6::Router.new
    router.draw do
      get Regexp.new("^/cats$"), CatsController, :index
      get Regexp.new("^/cats/\\d+$"), CatsController, :show
      get Regexp.new("^/cats/new$"), CatsController, :new
      post Regexp.new("^/cats$"), CatsController, :create
      get Regexp.new("^/cats/\\d+/edit$"), CatsController, :edit
      put Regexp.new("^/cats/\\d+$"), CatsController, :update
    end

    router
  end

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cat) { Cat.new }

  it "Defines route helpers on initialization" do
    controller = CatsController.new(req, res, {}, router.routes)
    expect(controller).to respond_to(:cats_url)
    expect(controller).to respond_to(:new_cats_url)
    expect(controller).to respond_to(:edit_cats_url)
  end


  it "Route helpers generate urls that match non-parametrized routes" do
    controller = CatsController.new(req, res, {}, router.routes)
    route = controller.cats_url
    expect(route).to eq("/cats")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:index)
  end

  it "Route helpers generate urls that match parametrized routes" do
    controller = CatsController.new(req, res, {}, router.routes)
    route = controller.cats_url(cat)
    expect(route).to eq("/cats/37")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:show)
  end

  it "Route helpers generate urls that match parametrized, verb postpended routes" do
    controller = CatsController.new(req, res, {}, router.routes)
    route = controller.edit_cats_url(cat)
    expect(route).to eq("/cats/37/edit")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("GET")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:edit)
  end

  it "Route matches correctly to HTTP method" do
    controller = CatsController.new(req, res, {}, router.routes)
    route = controller.cats_url(cat)
    expect(route).to eq("/cats/37")
    allow(req).to receive(:path).and_return(route)
    allow(req).to receive(:request_method).and_return("PUT")
    matched = router.match(req)
    expect(matched).not_to be(nil)
    expect(matched.action_name).to be(:update)
  end

end
