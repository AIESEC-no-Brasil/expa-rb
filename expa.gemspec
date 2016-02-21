# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expa/version'

Gem::Specification.new do |spec|
  spec.name          = 'expa'
  spec.version       = EXPA::VERSION
  spec.authors       = ['Marcus Vinícius de Carvalho - MC VP IM 2015-2016']
  spec.email         = ['marcus.carvalho@aiesec.net']

  spec.summary       = %q{This is an unofficial EXPA API developed by AIESEC in Brazil.}
  spec.description   = %q{This is an unofficial AIESEC EXPA API developed by AIESEC in Brazil. Please consult the website on github.com/AIESEC-no-Brasil/expa-rb.}
  spec.homepage      = 'http://www.aiesec.org.br'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
