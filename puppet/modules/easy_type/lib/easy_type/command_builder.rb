module EasyType
	class CommandBuilder
		attr_accessor :command, :line
		attr_reader :before_results, :after_results, :options

		def initialize(context, command, line = '', options = {})
			@context = context
			@command = command
			@before = []
			@after = []
			@line = line
			@before_results = []
			@after_results = []
			@options = options
		end

		def <<(line)
			@line << ' ' << line
			self
		end

		def before(command = nil)
			if command
				@before << command
				self
			else
				@before
			end
		end

		def after(command = nil)
			if command
				@after << command
				self
			else
				@after
			end
		end

		def execute
			@before.each do | before|
				@before_results << @context.send(@command, before, @options)
			end
			value = @context.send(@command, @line, @options )
			@after.each do | after|
				@after_results << @context.send(@command, after, @options)
			end
			value
		end

	end
end