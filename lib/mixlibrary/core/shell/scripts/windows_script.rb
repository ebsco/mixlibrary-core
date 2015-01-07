#All windows scripts will inherit from here
require "mixlibrary/core/shell/scripts/base"
require 'mixlibrary/core/apps/utilities'

module Mixlibrary
  module Core
    module Shell
      class Scripts
        class WindowsScript < Base
        
          protected
          
          @targetarchitecutre   = nil;
          @should_override      = nil
        
          def initialize(architecture)
            super()
        
            #The target arch is either what the machine is or passed in parameter
            @targetarchitecutre = architecture.nil? ?   Utilities::WindowsArchitectureHelper.architecture : architecture
            @should_override = Utilities::WindowsArchitectureHelper.wow64_architecture_override_required?(@targetarchitecutre)
            
            #why do we care here?  If user wants a 32bit process call the 32 bit executable?
            if ( @targetarchitecutre == :i386 )
              if (RubyInfo.architecture==:x86_64)
                raise "Support for the i386 architecture from a 64-bit Ruby runtime is not supported.  Please call the specific 32 bit assembly directly" 
              end
            end
          
          end
        
          def run_command(shell_executable, flags, filename_prefix, file_extension, code,shellout_options, eval_error)
            wow64_redirection_state = nil

            if @should_override
              #puts "Disabling redirection"
              wow64_redirection_state = Utilities::WindowsArchitectureHelper.disable_wow64_file_redirection()
            end
          
            begin
              return super(shell_executable, flags, filename_prefix, file_extension, code,shellout_options, eval_error)
            rescue
              raise
            ensure
              if ! wow64_redirection_state.nil?
                #puts "Restoring redirection"
                Utilities::WindowsArchitectureHelper.restore_wow64_file_redirection(wow64_redirection_state)
              end
            end
          end
        end
      end
    end
  end
end