# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mixlibrary/core/version'

Gem::Specification.new do |spec|
  spec.name          = Mixlibrary::Core::NAME
  spec.version       = Mixlibrary::Core::VERSION
  spec.authors       = ["Nicholas Carpenter"]
  spec.email         = ["ncarpenter@ebsco.com"]
  spec.summary       = %q{MixLib for creating Core libraries in ruby for automating machines.}
  spec.description   = %q{MixLib for creating Core libraries in ruby for automating machines.  This is an abstraction away from using Chef Providers directly to give us access to the lower layers of Chef implementation to meet additional use cases. }
  spec.homepage      = ""
  spec.license       = "Apache2"

  spec.files         = %w(LICENSE.txt README.md) + Dir.glob("lib/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "yard", "~> 0.8"    #needed for docs rake task
  spec.add_development_dependency "minitest-reporters"
  
  
  spec.add_dependency "chef" , ">= 11.16", "< 13"
  spec.add_dependency "win32-api" , ">= 1.5.1"
  
  
end
