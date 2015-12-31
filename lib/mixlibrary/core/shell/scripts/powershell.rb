#Runs powershell scripts with the least amount of intrusion possible.  We do some syntax checking and validation that the script did not end badly, but other than that, we 
#try to leave the executing script in the hands of the developer.
require "chef"
require "mixlibrary/core/shell/scripts/windows_script"

module Mixlibrary
  module Core
    module Shell
      class Scripts
        class Powershell < WindowsScript
          @originalScript   =nil
          @validate         =nil
          @options          =nil
          @flagoverrides    =nil
          
          def initialize(script, validate, options, flags, architecture = nil)
            super(architecture)
            @originalScript=script
            @options = options
            @validate=validate
            @flagoverrides=flags
          end
                  
          def orchestrate
            #Powershell kind of sucks with syntax checking.
            #If any part of the script syntactically fails it will exit with a clean exit code of 0
            #So this forced our hand to call powershell twice for every script call.
            #1 - Put passed in script in a function to see if any standard error is generated - 
            #only will happen if syntax is incorrect since function is never called
            #2 - Run the user script with exception wraps to guarantee some exit status
            syntax_check()
            
            myscriptstring = finalscript()
            
            return run_command(shell,flags,filename,file_extension, myscriptstring, @options, @validate)
          end

          private
          
          EXIT_STATUS_EXITCONVERSION = <<-EOF
          \#This function changes the exit code as desired back to ruby code.
            function exit-mixlibpowershell([int] $exitcode){
              [Environment]::Exit($exitcode)
            }
          EOF
          
          EXIT_STATUS_EXCEPTION_HANDLER=  <<-EOF
            trap [Exception]{
              write-error "Trapped in Trap Exception block" -erroraction continue;
              write-error -exception ($_.Exception.Message) -erroraction continue;
              exit-mixlibpowershell 1
            }
          EOF
          
          EXIT_STATUS_RESET_SCRIPT= <<-EOF 
          $LASTEXITCODE=0
          EOF
          
          #Make this set-variable call a read only.  Technically can be overridden but most of PS scripts that set this setting,
          #usually try to set this by doing things like $ERRORACTIONPREFERENCE="Stop"
          #Generally speaking this is the best way to handle this situation.  We will need to determine if there are many dependent scripts
          #that depend on being able to set this setting.
          EXIT_STATUS_INTIALIZATION= <<-EOF 
          
          Set-Variable -Name ERRORACTIONPREFERENCE -Value "STOP" -Scope Script -Option "ReadOnly" -force
          \#$ErrorActionPreference="STOP"
          try{
          EOF
          
          EXIT_STATUS_POST= <<-EOF 
          exit-mixlibpowershell $LASTEXITCODE
          }
          catch{
            write-error "Trapped in Catch block" -erroraction continue;
            write-error -exception ($_.Exception) -erroraction continue;
            exit-mixlibpowershell 1
          }
          EOF
          
          #Validate valid powershell was passed in.
          def syntax_check 
            local_script_contents=("function testme(){ \n #{@originalScript.to_s} \n} \n")
            
            result = run_command(shell,flags,filename,file_extension, local_script_contents, @options, false)
            #puts result.inspect
            if(result.stderr.length >= 1 || result.exitstatus !=0)
              #puts "Standard Output: \n #{result.stdout}"
              #puts "Standard Error: \n #{result.stderr}"
              raise RuntimeError,"Did not syntactically pass the powershell check.  \n Standard out: #{result.stdout} \n Standard Error:#{result.stderr}"
            end
          end
          
          def finalscript
            changed_script =
              EXIT_STATUS_EXITCONVERSION +
              EXIT_STATUS_EXCEPTION_HANDLER +
              EXIT_STATUS_RESET_SCRIPT +
              EXIT_STATUS_INTIALIZATION +
              @originalScript + 
              EXIT_STATUS_POST
                        
            return changed_script
          end
          
          def flags
            flags = [
              # Hides the copyright banner at startup.
              "-NoLogo",
              # Does not present an interactive prompt to the user.
              "-NonInteractive",
              # Does not load the Windows PowerShell profile.
              "-NoProfile",
              # always set the ExecutionPolicy flag
              # see http://technet.microsoft.com/en-us/library/ee176961.aspx
              "-ExecutionPolicy RemoteSigned",
              # Powershell will hang if STDIN is redirected
              # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
              "-InputFormat None",
          
              "-File"
            ]
            return @flagoverrides if @flagoverrides != nil
            return flags.join(' ')
          end  
       
          def shell
            return "powershell.exe"
          end
        
          def filename
            return "tempPSchef"
          end
        
          def file_extension
            return ".ps1"
          end
        
        end
      end
    end
  end
end