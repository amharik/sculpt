# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sculpt/version'

Gem::Specification.new do |gem|
  gem.name          = 'sculpt'
  gem.version       = Sculpt::VERSION
  gem.authors       = ['harikrishnan']
  gem.email         = ['harikrishnan.a@infibeam.net']
  gem.description   = %q{Rabl for models}
  gem.summary       = %q{Safe serialization of models to data objects}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rails', '=2.3.8'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake', '>=0.9'

end
