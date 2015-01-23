#Begin defining constant symbols for ruby versions

module Mixlibrary
  module Core
    module Utilities
      class RubyInfo
        
        def self.windows?
          if RUBY_PLATFORM =~ /mswin|mingw|windows/
            true
          else
            false
          end
        end
      
        def self.architecture
          #x64-mingw32
          #i386-mingw32
          myarch = RbConfig::CONFIG["arch"]
          if(myarch.upcase.include?("I386"))
            return :i386
          elsif (myarch.upcase.include?("X64"))
            return :x86_64
          else
            raise "Unsupported arch found: #{myarch}"
          end
        end
      end
    end
  end
end
