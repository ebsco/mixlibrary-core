require_relative 'spec_helper'
require 'mixlibrary/core/windows/features'

class TestWindowsFeature < Minitest::Test

  #only run the tests if on a windows machine
  if(windows?)

    #Make the hello world test to validate basic powershell is working
    def test_install_feature
      myclass=Mixlibrary::Core::Windows::Features.new("NLB")

      assert(myclass.is_installed? == false, "IIS was found to be installed")
      assert(myclass.is_feature_available? == true, "Failed to detect feature being available")
      myclass.install_feature()

      assert(myclass.is_installed? == true, "IIS was found to be NOT installed but should have been")
      assert(myclass.is_feature_available? == true, "Failed to detect feature being available")

      myclass.remove_feature()
      assert(myclass.is_installed? == false, "IIS was found to be installed")

    end
  end  
end
