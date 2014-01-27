# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enigma/version'

Gem::Specification.new do |spec|
  spec.name          = 'enigma_io'
  spec.version       = Enigma::VERSION
  spec.authors       = ['Stephen Pike']
  spec.email         = ['steve@scpike.net']
  spec.description   = 'Ruby client for the Enigma API'
  spec.summary       = 'Ruby client for the Enigma API'
  spec.homepage      = 'https://github.com/scpike/enigma'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = Dir.glob("{test/**/*}")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'

  spec.add_runtime_dependency 'typhoeus'
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'rubyzip', '>= 1.0.0'

  spec.required_ruby_version = '>= 1.9.3'
end
