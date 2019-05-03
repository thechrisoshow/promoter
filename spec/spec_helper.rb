$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "promoter"

require "webmock/rspec"
require "byebug"

Promoter.api_key = "ribeyeeulorem"

RSpec.configure do |config|
  config.define_derived_metadata(file_path: /spec\/v1/) do |metadata|
    metadata[:api_version] = 1
  end

  config.define_derived_metadata(file_path: /spec\/v2/) do |metadata|
    metadata[:api_version] = 2
  end


  config.before(:all, api_version: 1) do
    Promoter.api_version = 1
  end

  config.before(:all, api_version: 2) do
    Promoter.api_version = 2
  end
end

def fixture(filename)
  File.read("#{File.dirname(__FILE__)}/fixtures/v#{Promoter.api_version}/#{filename}")
end

def stub_get_request(url, json_file)
  stub_request(:get, url).
       to_return(status: 200, body: fixture(json_file))
end
