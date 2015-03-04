#We had our hand forced here.  We had to make this an instantianted class because the Ruby Include syntax does not work with entirely static methods.

module Mixlibrary
  module Core
    module Shell
      class ShellCall
        include Chef::Mixin::ShellOut
        
        def initialize
          
        end
      
        def shell(command, options)
          result = shell_out("#{command}", options)
          return result  
        end
      
        def shell!(command, options)
          result = shell_out!("#{command}", options)
          return result  
        end
      end
      
    end
  end
end
      
      
