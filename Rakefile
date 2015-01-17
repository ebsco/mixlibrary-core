require "bundler/gem_tasks"
require 'rubygems'
#require 'rake'
#require 'rake/clean'
#require 'rubygems/package_task'
#require 'rdoc/task'
require 'rake/testtask'
require 'mixlibrary/core/version'

GEM_NAME = Mixlibrary::Core::NAME
GEM_VERSION=Mixlibrary::Core::VERSION

task :default => :integration

#Run specific test: 
#   rake integration TESTOPTS="--name=test_run_powershell_script_call -v"
#Integration tests
Rake::TestTask.new(:integration => :build) do |t|
    t.test_files = FileList['test/**/*.rb']
  end
  

  
task :install  do
  sh %{gem install pkg/#{GEM_NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
end

task :uninstall  do
  sh %{gem uninstall #{GEM_NAME} -v '#{GEM_VERSION}' }
end

#documentation
begin
  require 'yard'
  DOC_FILES = [ "lib/**/*.rb" ]
  
  desc  "Create YARD documentation"

  YARD::Rake::YardocTask.new(:doc) do |t|
    t.files = DOC_FILES
    t.options = ['--format', 'html']
  end

rescue LoadError
  puts "yard is not available. (sudo) gem install yard to generate yard documentation."
  raise "Yard not available"
end