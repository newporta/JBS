# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jbs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andy Newport"]
  gem.email         = ["newportandy@gmail.com"]
  gem.description   = "JBS just builds sh*t"
  gem.summary       = "A simple git aware build runner"
  gem.homepage      = "https://github.com/newporta/JBS"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jbs"
  gem.require_paths = ["lib"]
  gem.version       = Jbs::VERSION

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
end
