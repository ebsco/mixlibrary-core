#Wraps calling shell out with any script file.  Will create the script file execute the shell out command and delete the file once complete

require "mixlibrary/core/shell/shell_call"
module Mixlibrary
  module Core
    module Shell
      class Scripts
        class ShellOutWrapper
          @exe
          @flags
          @filename
          @fileext
          @code
          @shellout_options
        
          #runtime
          @script_file
        
          def initialize(exe, flags, filename, fileext, code, shellout_options)
            @exe=exe
            @flags=flags
            @filename=filename
            @fileext=fileext
            @code=code
            if(shellout_options==nil)
              @shellout_options= Hash.new()
            else
              @shellout_options=shellout_options
            end
          end

          public
          #Supported options
          #opts[:domain]
          #opts[:password]
          #opts[:timeout] = @new_resource.timeout || 3600
          #opts[:returns] = @new_resource.returns if @new_resource.returns
          #opts[:environment] = @new_resource.environment if @new_resource.environment
          #opts[:user] = @new_resource.user if @new_resource.user
          #opts[:group] = @new_resource.group if @new_resource.group
          #opts[:cwd] = @new_resource.cwd if @new_resource.cwd
          #opts[:umask] = @new_resource.umask if @new_resource.umask
          #opts[:log_level] = :info
          #opts[:log_tag] = @new_resource.to_s
          #cmd = Chef::ShellOut.new("apachectl", "start", :user => 'www', :env => nil, :cwd => '/tmp')
          #puts "#{script_file.path}"
            
          def run_command
            return shellout(false)
          end
        
          def run_command!
            return shellout(true)
          end

          private
          
          def set_owner_and_group
            # FileUtils itself implements a no-op if +user+ or +group+ are nil
            # You can prove this by running FileUtils.chown(nil,nil,'/tmp/file')
            # as an unprivileged user.
            #puts "#{@shellout_options.inspect}"
            ::FileUtils.chown(@shellout_options[:user], @shellout_options[:group], @script_file.path)
          end
        
          def script_file
            #puts "File name #{filename}"
            @script_file ||= Tempfile.open([@filename, @fileext])
          end
        
          def unlink_script_file
            @script_file && @script_file.close!
            @script_file=nil
          end
        
          def create_file ()
            #Output script to file path
            script_file.puts(@code)
            script_file.close
          
            set_owner_and_group
          end
      
          def shellout(eval_error)
            begin
              create_file()
      
              shellclass=Shell::ShellCall.new
              if(eval_error)  
                result = shellclass.shell!("#{@exe} #{@flags} #{@script_file.path}", @shellout_options)
                return result  
              else
                result = shellclass.shell("#{@exe} #{@flags} #{@script_file.path}", @shellout_options)
                return result
              end
            
            rescue  Exception => e  
              #puts e.message  
              #puts e.backtrace.inspect  
              raise 
            
            ensure
              unlink_script_file
            end
          end
          
        end
      end
    end
  end
end
