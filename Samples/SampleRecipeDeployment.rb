gem_version="0.0.9"

myexecuteaction = execute 'gem update --system' do
  not_if do	
			def isgreater
				output=`"gem" -v`
				puts "Version found: #{output}"
				
				myvar=output.gsub(/\s+/, "")
				individual=myvar.split(".") 
				 raise "Invalid version detected" if individual.length < 2
				 
				#Greater than or equal to 2.4
				return false if individual[0].to_i < 2
				return false if individual[1].to_i < 4	
				
				return true
			end
			
			retval = isgreater()
			puts "Is greater:#{retval}"
			#return  --- Cannot use the return statement - breaks chef DSL apparently
			retval
	end
end

myexecuteaction.run_action(:run)



mycustomgem = gem_package "my_gem_package_resource" do
  package_name "mixlibrary-core"
  options "--minimal-deps" 
  version gem_version
  action :nothing
end

mycustomgem.run_action(:install)

#Make available in current process by clearing paths
#Require calls to mixlib need to be in method calls since they need to be "delayed" because of Chef loading order. https://sethvargo.com/using-gems-with-chef/
#Right now we are telling everyone to lazy load their require statements.  No matter what this is a hack.  Might be a Chef issue that needs to be opened up.
::Gem.clear_paths 