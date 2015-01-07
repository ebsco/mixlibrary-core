#This file defines the typical entrypoint into this shell code base.  Other entrypoints can be used, but this one is currently made easiest
#by including an apps folder at the top level and including this file to get the pieces that are needed.

#Could you easily enough require the powershell.rb directly and just outright call it, sure.  But most if not all of this code should be stateless.  This
#implies static methods should be used.  After a bunch of reading, there seems to be no real consensus on where static methods belong.  I like the idea of classes
#but I found more people sticking these methods in the base module, which is what I am doing here.  So the way one can interpret this file is it is the base methods
#that are exposed in its entirety for the Shell (sub-module) within this Gem.  Since everything is stateless no need to expose classes directly unless it is overwhelmingly
#more complicated and many methods would need to be exposed (Scalability).  (We are just scripting after all....)

require 'mixlibrary/core/shell/scripts/powershell'
require "mixlibrary/core/shell/shell_call"

module Mixlibrary
  module Core
    module Shell
      
      #########################
      #Scripts
      #########################
      def self.windows_script_out(shellType,script, options=nil, flags=nil,desiredarchitecture=nil)
        return run_windows_script(shellType,false,script, options, flags,desiredarchitecture)
      end
      
      def self.windows_script_out!(shellType,script, options=nil, flags=nil,desiredarchitecture=nil )
        return run_windows_script(shellType,true,script, options, flags,desiredarchitecture)
      end
      
      #########################
      #Shell Out
      #########################
      def self.shell_out!(command, options=nil)
        shellclass=Shell::ShellCall.new
        return shellclass.shell!(command, options)
      end     
      
      def self.shell_out(command, options=nil)
        shellclass=Shell::ShellCall.new
        return shellclass.shell(command, options)
      end
      
      private 
      def self.run_windows_script(shellType, validate, script, options, flags, architecture)
        case shellType
        when :powershell
          
          obj= Shell::Scripts::Powershell.new(script, validate, options, flags,architecture)
          return obj.orchestrate
        
        else
          raise "Shell not supported.  Currently supports: :powershell for now!"
        end
      end
    end
  end
end
