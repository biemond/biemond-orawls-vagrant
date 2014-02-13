[![Code Climate](https://codeclimate.com/github/hajee/easy_type.png)](https://codeclimate.com/github/hajee/easy_type) [![Build Status](https://travis-ci.org/hajee/easy_type.png)](https://travis-ci.org/hajee/easy_type) [![Dependency Status](https://gemnasium.com/hajee/easy_type.png)](https://gemnasium.com/hajee/easy_type) [![Coverage Status](https://coveralls.io/repos/hajee/easy_type/badge.png)](https://coveralls.io/r/hajee/easy_type)


easy_type
===============
This module makes it easier to create custom types. To create a custom type use:

```ruby
require 'easy_type'

module Puppet
  #
  # Create a new type oracle_user. Oracle user, works in conjunction 
  # with the SqlResource provider
  #
  newtype(:a_custom_type) do
    include EasyType

    ensurable
    #
    # Use set_command to set the base command given on createing, destroying and modifying 
    # the resource
    #
    set_command(:just_a_method)


    to_get_raw_resources do
    	#
    	# Fill in the code needed to get an array of reseources. The array must contain Hashes
    	# the Hash can have arbitrary elements. 
    	#

    end

    on_create do
			# this is the statement that is added to the command (see set_command) to create a resource
			# You can reference all type information using self[:attr] where :attr is a parameter or property 
			# of the type 
      "create user #{self[:name]}"
    end

    on_modify do
			# this is the statement that is added to the command (see set_command) to modify a resource
			# You can reference all type information using self[:attr] where :attr is a parameter or property 
			# of the type 
      "alter user #{self[:name]}"
    end

    on_destroy do
			# this is the statement that is added to the command (see set_command) to destroy a resource
			# You can reference all type information using self[:attr] where :attr is a parameter or property 
			# of the type 
      "drop user #{self[:name]}"
    end

    newparam(:name) do
      include EasyType
      include EasyType::Validators::Name 	# Check easy_type/validators for available validators
      include EasyType::Mungers::upcase   # Check easy_type/validators for available mungers

      desc "The user name"

      isnamevar

      #
      # Use this method to pick a part for the raw_resource hash. and translate it to the real resource hash
      #
      to_translate_to_resource do | raw_resource|
        raw_resource['USERNAME'].upcase
      end


    end

    newproperty(:user_id) do
      include EasyType

      include EasyType::Validators::Integer 	# Check easy_type/validators for available validators
      include EasyType::Mungers::Integer			# Check easy_type/validators for available mungers

      desc "The user id"

      #
      # Use this method to pick a part for the raw_resource hash. and translate it to the real resource hash
      #
      to_translate_to_resource do | raw_resource|
        raw_resource['USER_ID'].to_i
      end

      #
      # Use this method to append specific information for a porperty to the create or the update commands
      #
      on_apply do
        "default tablespace #{resource[:default_tablespace]}"
      end

    end

  end
end

```

to use this resource, You must add the next file into the provider directory

```ruby
require 'easy_type'

Puppet::Type.type(:a_custom_type).provide(:simple) do
  include EasyType::Provider

  mk_resource_methods

end
```


License
-------

MIT License


Contact
-------
Bert Hajee hajee@moretIA.com

Support
-------
Please log tickets and issues at our [Projects site](https://github.com/hajee/easy_type)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/hajee/easy_type/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

