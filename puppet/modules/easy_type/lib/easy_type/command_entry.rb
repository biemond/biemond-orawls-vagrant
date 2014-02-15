class CommandEntry

	attr_reader :command, :arguments, :context

	def self.set_binding(the_binding)
		@@binding = the_binding
	end

	def initialize(command, arguments)
		@command = command
		@arguments = Array(arguments)
	end


	def execute
		normalized_command = RUBY_VERSION == "1.8.7" ? command.to_s : command.to_sym
		if @@binding.methods.include?(normalized_command)
			@@binding.send(normalized_command, *normalized_arguments)
		else
			full_command = arguments.dup.unshift(command).join(' ') 
			Puppet::Util::Execution.execute(full_command,:failonfail => true)
		end
	end

	private
	def normalized_arguments
		if arguments.length > 1
			arguments.join(' ')
		else
			arguments
		end
	end

end
