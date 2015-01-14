#only needed for testing outside of chef executions.  Should not be called from within a Chef Run
unless defined?(Chef::Mixin::ShellOut)
  require 'chef'
end
unless defined?(Chef::Log)
  require 'chef'
end
