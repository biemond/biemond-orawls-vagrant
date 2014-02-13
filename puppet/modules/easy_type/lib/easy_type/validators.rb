module EasyType
	module Validators
		module Name

		  ##
		  #
		  # This validator validates if a name is free of whitespace and not empty. To use this validator, include
		  # it in a Puppet name definition.
		  #
		  # Example:
		  #  
		  #    newparam(:name) do
			#      include ::Utils::Validators::NameValidator
      #				desc "The database name"
      #  			isnamevar
		  #
		  # @raise [Puppet::Error] when the name is invalid
		  #
			def validate(value)
        raise Puppet::Error, "Name must not contain whitespace: #{value}" if value =~ /\s/
        raise Puppet::Error, "Name must not be empty" if value.empty?
      end

		end


		module Integer

		  ##
		  # TODO: Add Api description
		  #
			def validate(value)
        raise Puppet::Error, "Invalid integer value: #{value}" if value =~ /^\d+$/
      end

		end

	end
end
