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

		#
		# retuns the results from on_apply for all the fields specified. 
		# Only return the field when it is not already managed by a normal
		# change.
		#
		# examples:
		#
		# on_apply do
    #  	"#{touch([:autoextend, :next]).join(' ')} maxsize #{should}"
		# end
		#
		# on_apply do
    #  	"#{touch :autoextend} maxsize #{should}"
		# end
		#
		def touch(fields)
			fields = Array(fields)
			fields.collect do | field|
				touch_field(field)
			end
		end

		private

			def touch_field(field)
				klass = property_class(field)
				#
				# if the property is insync, we expect the normal handler to
				# handle this case
				#
				klass.on_apply if klass.value == klass.should
			end

			def property_class(field)
				klass = resource.properties.select {|p| p.name == field}.first
				fail "field #{field} not defined." unless klass
				klass
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