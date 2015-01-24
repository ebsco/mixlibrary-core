# x86-mingw32 Gemspec #
gemspec = eval(IO.read(File.expand_path("../mixlibrary-core.gemspec", __FILE__)))

gemspec.platform = "x86-mingw32"
gemspec.add_dependency "win32-api" , ">= 1.5.1"

gemspec