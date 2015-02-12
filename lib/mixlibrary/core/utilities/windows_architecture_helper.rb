require 'mixlibrary/core/utilities/ruby_info'
require 'win32/api' if Mixlibrary::Core::Utilities::RubyInfo.windows?

module Mixlibrary
  module Core
    module Utilities
      class WindowsArchitectureHelper
      
        #Attempts to determine if this machine is 64 bit or not in a variety of ways - using generic ruby and/or Windows specific environment variabes
        def self.is_machine_64bit?
          if(RubyInfo.architecture==:x86_64)
            return true
          end
        
          if(ENV.has_key?('ProgramFiles(x86)'))
            return true;
          end
        
          if(ENV.has_key?('PROCESSOR_ARCHITEW6432'))
            return true;
          end        
          
          return false;
        end
      
        #returns the architecture based on if the machine is 64 bit
        def self.architecture
          if(is_machine_64bit?)
            return :x86_64
          else
            return :i386
          end
        end
      
        #Determines if the syswow redirection needs to be disabled based on the desired architecture.
        def self.wow64_architecture_override_required?(desired_architecture)
          #only use case we need to disable redirection is if
          #running as 32 bit
          #want 64 bit
          #On 64bit machine
          RubyInfo.architecture==:i386 &&
            desired_architecture == :x86_64  &&
            is_machine_64bit?
          
        end
      
        #Disables syswow redirection
        def self.disable_wow64_file_redirection()
          original_redirection_state = ['0'].pack('P')
        
          win32_wow_64_disable_wow_64_fs_redirection =
            ::Win32::API.new('Wow64DisableWow64FsRedirection', 'P', 'L', 'kernel32')

          succeeded = win32_wow_64_disable_wow_64_fs_redirection.call(original_redirection_state)

          if succeeded == 0
            raise  "Failed to disable Wow64 file redirection"
          end

          return original_redirection_state
        end

        #Restore syswow redirection
        def self.restore_wow64_file_redirection(original_redirection_state )
        
          win32_wow_64_revert_wow_64_fs_redirection =
            ::Win32::API.new('Wow64RevertWow64FsRedirection', 'P', 'L', 'kernel32')

          succeeded = win32_wow_64_revert_wow_64_fs_redirection.call(original_redirection_state)

          if succeeded == 0
            raise  "Failed to revert Wow64 file redirection"
          end
        end
        
      end
    end
  end
end