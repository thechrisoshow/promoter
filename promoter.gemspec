# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'promoter/version'

Gem::Specification.new do |spec|
  spec.name          = "promoter"
  spec.version       = Promoter::VERSION
  spec.authors       = ["Chris O'Sullivan"]
  spec.email         = ["thechrisoshow@gmail.com"]
  spec.homepage      = "https://developers.promoter.io/"

  spec.summary       = %q{promoter is a wrapper for the promoter.io REST API}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"

  spec.add_dependency "httparty"
  spec.add_dependency "json"
end
