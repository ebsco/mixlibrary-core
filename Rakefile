require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'
require 'mixlibrary/core/version'

GEM_NAME    = Mixlibrary::Core::NAME
GEM_VERSION =  Mixlibrary::Core::VERSION

#Dynamic tasks
#Package task for each gemspec file
Dir[File.expand_path("../*gemspec", __FILE__)].reverse.each do |gemspec_path|
  gemspec = eval(IO.read(gemspec_path))
  Gem::PackageTask.new(gemspec).define
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


#Static tasks
task :default => :integration
task :build => :gem

#Run specific test: 
#   rake integration TESTOPTS="--name=test_run_powershell_script_call -v"
#Integration tests
Rake::TestTask.new(:integration => :build) do |t|
  t.test_files = FileList['test/**/*.rb']
end
  

desc "Build it, tag it and ship it"
task :release => :gem do
  if(ENV['tag']!='false')
    sh("git tag #{GEM_VERSION}")
    sh("git push origin --tags")
  end
  Dir[File.expand_path("../pkg/*.gem", __FILE__)].reverse.each do |built_gem|
    sh("gem push #{built_gem}")
  end
end
  
task :install  do
  sh %{gem install pkg/#{GEM_NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
end

task :uninstall  do
  sh %{gem uninstall #{GEM_NAME} -v '#{GEM_VERSION}' }
end
