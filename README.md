# Mixlibrary-Core
[![GitHub](http://img.shields.io/badge/github-ebsco/mixlibrary-blue.svg)](https://github.com/ebsco/mixlibrary-core)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/mixlibrary-core/frames)

[![Gem Version](https://badge.fury.io/rb/mixlibrary-core.svg)](https://github.com/ebsco/mixlibrary-core/releases)
[![Build Status](https://api.travis-ci.org/ebsco/mixlibrary-core.svg?branch=master)](https://travis-ci.org/ebsco/mixlibrary-core)
[![License](http://img.shields.io/badge/license-Apache2-yellowgreen.svg)](https://github.com/ebsco/mixlibrary-core/blob/master/LICENSE.txt)

Wraps some provider functionality from chef into easily consumable ruby classes that do not have the extra baggage of being dependent on Chef data objects.  Node object, Environment etc.

## Installation

Add this line to your application's Gemfile:

    gem 'mixlibrary-core'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mixlibrary-core

## How to Install via Chef Recipe
* [Recipe Install Sample](https://github.com/ebsco/mixlibrary-core/blob/master/Samples/SampleRecipeDeployment.rb)
		
## Documentation
* Uses yard to document classes and methods.  Generate docs or automatic documentation: http://www.rubydoc.info
    *       rake doc

## Usage

### Windows Oriented

#### Powershell Scripts
Needed ability to execute powershell scripts and get the powershell process back.  So to execute a powershell script:

```
require 'mixlibrary/core/apps/shell'
     
script= <<-EOF
    write-host "Hello 'World'"
EOF

procobj = Mixlibrary::Core::Shell.windows_script_out!(:powershell,script)
``` 

#### Batch
Not Implemented yet

### Linux Oriented


## Contributing
    # Run All the Tests on your platform and build the gem
    
    bundle install    

    bundle exec rake


		

1. Fork it (http://github.com/<my-github-username>/mixlibrary-core/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
