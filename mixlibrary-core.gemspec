# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mixlibrary/core/version'

#GEM_NAME = Mixlibrary::Core::NAME

Gem::Specification.new do |spec|
  spec.name          = Mixlibrary::Core::NAME
  spec.version       = Mixlibrary::Core::VERSION
  spec.authors       = ["Nicholas Carpenter"]
  spec.email         = ["ncarpenter@ebsco.com"]
  spec.summary       = %q{MixLib for creating Core libraries in ruby for automating machines.}
  spec.description   = %q{MixLib for creating Core libraries in ruby for automating machines.  This is an abstraction away from using Chef Providers directly to give us access to the lower layers of Chef implementation to meet additional use cases. }
  spec.homepage      = "https://www.ebsco.com/"
  spec.license       = "Apache2"

  spec.files         = %w(LICENSE.txt README.md) + Dir.glob("lib/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "yard", "~> 0.8"    #needed for docs rake task
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  
  #Make install explicitly fail in 11 instead of silent failing
  spec.required_rubygems_version = '>=2.4'
  
  spec.add_dependency "chef" , ">= 11.16", "< 13"
  
  
  #Cant assume this available apparently - workaround is to use extensions
  #spec.add_dependency "win32-api" , ">= 1.5.1"
  #This line tells rubygems to look for an extension to install
  #spec.extensions = ["ext/mkrf_conf.rb"]
  
  
end
