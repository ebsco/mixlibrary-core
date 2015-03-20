require 'mixlibrary/core/apps/shell'
#require 'mixlibrary/core/windows/features'
#myclass=Mixlibrary::Core::Windows::Features.new("Web-Server")
module Mixlibrary
  module Core
    module Windows
      class Features

        def initialize(feature_name)
          if feature_name.to_s.strip.length == 0
            # It's nil, empty, or just whitespace
            raise "Feature name cannot be empty or just white space"
          end

          @feature_name=feature_name
        end

        def remove_feature()
          Chef::Log.info("Removing feature:#{@feature_name}")
          script= <<-EOF
            import-module ServerManager;
            Remove-WindowsFeature -Name "#{@feature_name}"
          EOF

          procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell, script)
          Chef::Log.debug("Command output: #{procobj.stdout}")
        end

        def install_feature()
          Chef::Log.info("Installing feature:#{@feature_name}")
          script= <<-EOF
            import-module ServerManager;
            Add-WindowsFeature -Name "#{@feature_name}"
          EOF

          procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell, script)
          Chef::Log.debug("Command output: #{procobj.stdout}")
        end

        def is_feature_available?()
          Chef::Log.info("Is feature available:#{@feature_name}")
          script= <<-EOF
            import-module ServerManager;
            $myvar=@(get-WindowsFeature -Name #{@feature_name})

            if($myvar.Count -eq 0){
                write-host "Found no matching features"
                exit 6
            }

          write-host "Printing Matching Features"
          foreach($myfeature in $myvar){
            $myfeature | ft -Property FeatureType,DisplayName,Name,InstallState,Installed | Out-Host
          }

          exit 5

          EOF

          procobj = Mixlibrary::Core::Shell.windows_script_out(:powershell, script)
          Chef::Log.info("Command output:#{procobj.stdout}")

          return procobj.stderr.empty? && procobj.stdout !~ /Removed/i && procobj.exitstatus==5
        end

        def is_installed?
          Chef::Log.info("Is feature installed:#{@feature_name}")
          #Need to handle this use case: Get-WindowsFeature Web* | Select Installed | % { Write-Host $_.Installed }
          #(cmd.stdout =~ /true/i) != nil ---There needs to be one true
          #(cmd.stdout =~ /False/i) == nil ---There needs to be no false
          #And no standard error
          script= <<-EOF
              import-module ServerManager;
              Get-WindowsFeature -Name #{@feature_name} | Select Installed | % { Write-Host $_.Installed }
          EOF

          procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell, script)
          Chef::Log.debug("Command output:#{procobj.stdout}")
          procobj.stderr.empty? && (procobj.stdout =~ /False/i) == nil && (procobj.stdout =~ /true/i) != nil

        end

        private
        def above_2008r2?
          if RUBY_PLATFORM =~ /mswin|mingw32|windows/
            require 'chef/win32/version'
            win_version = Chef::ReservedNames::Win32::Version.new
            #"Windows Server 2008 R2" => {:major => 6, :minor => 1
            major = win_version.instance_variable_get("@major_version")
            minor = win_version.instance_variable_get("@minor_version")

            if major >= 6 && minor > 1
              return true
            end

            return false
          end

          raise 'Calling this method on any system but Windows is unsupported'
        end
      end
    end
  end
end