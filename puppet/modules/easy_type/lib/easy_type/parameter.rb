module EasyType
	#
	# This module contains all extensions for the Parameter class used by EasyType
	# To use it, include the following statement in your parameter of property block
	#
	#  	include EasyType::Parameter
	#
	#
	module Parameter

		def self.included(parent)
			parent.extend(ClassMethods)
		end

		module ClassMethods
			#
			# retuns the string needed to modify this specific property of a  an sql type
			#
			# example:
			#
			# newproperty(:password) do
	    #   on_apply do
	    #     "identified by #{resource[:password]}"
	    #   end
	    # end
			def on_apply(&block)
				define_method(:on_apply, &block) if block
			end

			#
			# maps a raw resource to retuns the string needed to modify this specific property of a  an sql type
			#
			# example:
			#
			# newproperty(:password) do
	    #   map do
	    #     "identified by #{resource[:password]}"
	    #   end
	    # end
			def to_translate_to_resource(&block)
				eigenclass = class << self; self; end
				eigenclass.send(:define_method, :translate_to_resource, &block)
			end
		end
	end
end