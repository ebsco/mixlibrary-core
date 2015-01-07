require "mixlibrary/core/shell/scripts/shelloutwrapper"

module Mixlibrary
  module Core
    module Shell
      class Scripts
        
        #Base class for all script classes.  Provides an Interface of sorts that all other classes must implement and also provides the base methods that would need to be implemented.
        class Base
        
          #Orchestrates running the script.  Might be as simple as calling shell_out or more complicated like doing syntax validation of the script before execution 
          def orchestrate
            raise "Not Implemented Exception"
          end
          
          protected
                    
          def run_command(shell_executable, flags, filename_prefix, file_extension, code,shellout_options, eval_error)
            shellobj =Scripts::ShellOutWrapper.new(shell_executable, flags, filename_prefix, file_extension, code, shellout_options)
        
            if(eval_error)
              return shellobj.run_command!
            else
              return shellobj.run_command
            end  
          end
        end
        
      end
    end
  end
end
