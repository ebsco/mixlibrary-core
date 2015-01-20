require_relative 'spec_helper'
require 'mixlibrary/core/apps/shell'

class Powershell < Minitest::Test

  #only run the tests if on a windows machine
  if(windows?)

    #Make the hello world test to validate basic powershell is working
    def test_helloworld
      #puts "helloworld"
      script= <<-EOF
      write-host "Hello 'World'"
      EOF
      procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell,script)
      #puts "Result:#{procobj.inspect}"
      assert_equal(procobj.exitstatus, 0)
      assert_equal(procobj.stderr, '')
      assert_equal(procobj.stdout, "Hello 'World'\n")
    end
  
    #Test standard output
    def test_standard_output
      #puts "standard_output:"
      script= <<-EOF
      get-childitem c:/
      EOF
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
      #puts "Result:#{procobj.inspect}"
      assert_equal(procobj.exitstatus, 0)
      assert_equal(procobj.stderr, '')
      assert(procobj.stdout.lines.count >=5)
    end
  
    #Exit and propagate
    def test_propagatedexitcode
      #puts "propagatedexitcode"
      script= <<-EOF
      write-host "Hello 'World'"
    exit 1
      EOF
      #procobj = windows_script_out!(:powershell,script)
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
      #puts "Result:#{procobj.inspect}"

      assert_equal(procobj.exitstatus, 1)
      assert_equal(procobj.stderr, '')
      assert_equal(procobj.stdout, "Hello 'World'\n")
    end
  
    #Bad call to cmdlet validate it gives back exit code of 1
    def test_invalid_ps_cmdletcall
      #puts "invalid_ps_cmdletcall:"
      script= <<-EOF
      get-childitem c:/ssss
      EOF
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
      assert_equal(procobj.exitstatus, 1)
      assert(procobj.stderr.lines.count>3)
      assert_equal(procobj.stdout, "")
    end
    
    def test_run_powershell_script_call
      filename = ::File.join(ENV["TEMP"].gsub("\\","/"),"test.ps1");
      begin
        File.write(filename, 'exit 5')
        script= <<-EOF
        #{filename}
        EOF
        procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
        assert_equal(5, procobj.exitstatus)
      ensure
        
        File.delete(filename)
      end
    end
    
    def test_run_powershell_script_call_negative
      filename = ::File.join(ENV["TEMP"].gsub("\\","/"),"test.ps1");
      begin
        File.write(filename, '[Environment]::Exit(-5)')
        script= <<-EOF
        #{filename}
        EOF
        procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
        assert_equal(-5, procobj.exitstatus)
      ensure
        
        File.delete(filename)
      end
    end
  
    #Bad call to cmdlet validate it gives back exit code of 1 in this case breaks
    def test_invalid_ps_cmdletcall_fail
      #puts "invalid_ps_cmdletcall_fail:"
      assert_raises Mixlib::ShellOut::ShellCommandFailed do
        script= <<-EOF
        get-childitem c:/ssss
        EOF
        procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell,script)
      end
    end
  
    def test_syntaxcheck
      #bad example - invalid syntax check
      #puts "syntaxcheck:"
      myvar = assert_raises RuntimeError do
        script= <<-EOF
      write-host "Hello 'World

        EOF
        procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
        #puts "Result:#{procobj.inspect}"
      end
      #puts "Result:#{myvar.inspect}"
    end
  
    #See here how a valid ps file can modify the EA var.  DO NOT DO THIS
    #We stop the typical use case by making the variable read only
    def test_unsupported_ea_pref_set
      #puts "Unsupported EA setting:"
      script= <<-EOF
      #DO NOT DO THIS - DO NOT DO THIS
      $ERRORACTIONPREFERENCE="Continue"
      get-childitem c:/ssssdas
      EOF
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script)
      #puts "Result:#{procobj.inspect}"
      assert_equal(procobj.exitstatus, 1)
      assert(procobj.stderr.lines.count>2)
      assert_equal(procobj.stdout , '')
    end
  
    def test_send_sample_shell_args
      #puts "send_sample_shell_args"
      script= <<-EOF
      write-host $pwd
      EOF
    
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script, {:returns => [0,2],:cwd => 'C:/'})
      #puts "ERROR LOOKING #{procobj.inspect}"
      assert_equal(procobj.exitstatus, 0)
      assert_equal(procobj.stderr,'')
      assert_equal(procobj.stdout , "C:\\\n")
    
    end
  
    def test_send_invalid_shell_args_without_checking
      #puts "send_invalid_shell_args"
      script= <<-EOF
      write-host $pwd
      EOF
    
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script, {:returns => [1]})
      assert_equal(procobj.exitstatus, 0)
      assert_equal(procobj.stderr,'')
      assert_equal(procobj.stdout , "#{Dir.pwd.gsub("/","\\\\")}\n")
    
    end
  
    def test_send_invalid_shell_args_with_checking
      #puts "send_invalid_shell_args_withChecking"
      script= <<-EOF
      write-host $pwd
      EOF

      myvar = assert_raises Mixlib::ShellOut::ShellCommandFailed do
        procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell,script, {:returns => [1]})
      end
    
      myvar = nil
    end
  
    def test_send_flag_changes_only
      #puts "send_invalid_shell_args"
      script= <<-EOF
      write-host $pwd
      EOF
    
      procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell,script,nil,"-NonInteractive -ExecutionPolicy unrestricted -InputFormat None -File" )
      #puts "Debugging #{procobj.inspect}"
      assert_equal(procobj.exitstatus, 0)
      assert_equal(procobj.stderr,'')
      assert_equal(procobj.stdout , "#{Dir.pwd.gsub("/","\\\\")}\n")
      assert(procobj.command.include?("unrestricted"))
    end  
  end  
end
