# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'answer/version'

Gem::Specification.new do |spec|
  spec.name          = "answer"
  spec.version       = Answer::VERSION
  spec.authors       = ["Dominik Bylica"]
  spec.email         = ["byldominik+fenoloftaleina@gmail.com"]

  spec.summary       = %q{A json-renderable result object working well with AR, AM Serializers, and Rails.}
  spec.homepage      = "https://github.com/fenoloftaleina/answer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "active_model_serializers", "~> 0.9.0"
  spec.add_development_dependency "activesupport"
end
