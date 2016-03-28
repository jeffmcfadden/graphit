# coding: utf-8 #


lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphit/version'

Gem::Specification.new do |spec|
  spec.name          = "graphit"
  spec.version       = Graphit::VERSION
  spec.authors       = ["jeffmcfadden"]
  spec.email         = ["jeff@forgeapps.com"]

  spec.summary       = %q{Super basic graphic library that writes data to BMP files.}
  spec.description   = %q{Probably not robust enough to do what you want. I use it to conver mrtg data to scalable graphs.}
  spec.homepage      = "https://github.com/jeffmcfadden/graphit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'bin_utils'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
