require 'webrick'
require_relative '../lib/phase4/controller_base'
require_relative '../lib/bonus/flash'

describe Flash do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cook) { WEBrick::Cookie.new('_rails_lite_app_flash', { xyz: 'abc' }.to_json) }
  let(:now_cook) { WEBrick::Cookie.new('_rails_lite_app_flash', {now: { xyz: 'abc' }}.to_json) }

  it "deserializes json cookie if one exists, and moves data to now_hash" do
    req.cookies << cook
    flash = Flash.new(req)
    expect(flash.now['xyz']).to eq('abc')
  end

  it "deserializes json cookie if one exists, and purges the now_hash if it exists" do
    req.cookies << now_cook
    flash = Flash.new(req)
    expect(flash.now['xyz']).to be(nil)
  end

  describe "#store_flash" do
    context "without cookies in request" do
      before(:each) do
        flash = Flash.new(req)
        flash['first_key'] = 'first_val'
        flash.store_flash(res)
      end

      it "adds new cookie with '_rails_lite_app_flash' name to response" do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        expect(cookie).not_to be_nil
      end

      it "stores the cookie in json format" do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        expect(JSON.parse(cookie.value)).to be_instance_of(Hash)
      end
    end

    context "with cookies in request" do
      before(:each) do
        cook = WEBrick::Cookie.new('_rails_lite_app_flash', { now: {"rightnow" => "hotsoup"}, pho: "soup" }.to_json)
        req.cookies << cook
      end

      it "moves the pre-existing flash data into the now hash" do
        flash = Flash.new(req)
        expect(flash["pho"]).to be_nil
        expect(flash.now["pho"]).to eq("soup")
      end


      it "saves new data to the flash, moves old data to the now_hash" do
        flash = Flash.new(req)
        flash['machine'] = 'mocha'
        flash.store_flash(res)
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
        h = JSON.parse(cookie.value)
        expect(h['now']['pho']).to eq('soup')
        expect(h['machine']).to eq('mocha')
      end
    end
  end
end

describe Phase4::ControllerBase do
  before(:all) do
    class CatsController < Phase4::ControllerBase
    end
  end
  after(:all) { Object.send(:remove_const, "CatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { CatsController.new(req, res) }

  describe "#flash" do
    it "returns a flash instance" do
      expect(cats_controller.flash).to be_a(Flash)
    end

    it "returns the same instance on successive invocations" do
      first_result = cats_controller.flash
      expect(cats_controller.flash).to be(first_result)
    end
  end

  shared_examples_for "storing flash data" do
    it "should store the flash data" do
      cats_controller.flash['test_key'] = 'test_value'
      cats_controller.send(method, *args)
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h['test_key']).to eq('test_value')
    end

    it "should store data in the now hash" do
      cats_controller.flash.now = ({'test_key' => 'test_value'})
      cats_controller.send(method, *args)
      cookie = res.cookies.find { |c| c.name == '_rails_lite_app_flash' }
      h = JSON.parse(cookie.value)
      expect(h.keys).not_to include('test_key')
      expect(h['now']['test_key']).to eq('test_value')
    end
  end

  describe "#render_content" do
    let(:method) { :render_content }
    let(:args) { ['test', 'text/plain'] }
    include_examples "storing flash data"
  end

  describe "#redirect_to" do
    let(:method) { :redirect_to }
    let(:args) { ['http://appacademy.io'] }
    include_examples "storing flash data"
  end
end
