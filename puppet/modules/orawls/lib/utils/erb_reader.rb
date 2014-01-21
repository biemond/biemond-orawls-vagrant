module Utils
  module ERBReader
    def erb_template(name, context)
      full_name = get_erb_file(name)
      raise ArgumentError, "file #{name} not found" unless full_name
      ERB.new(IO.read(full_name)).result(context)
    end

    private
      # @private
      def get_erb_file(name)
        name = name + '.erb' unless name =~ /\.erb$/
        dir = $LOAD_PATH.find { |dir| path_name(dir, name).exist?}
        dir and path_name(dir, name)
      end

      def path_name(dir, name)
        Pathname.new(dir).parent + 'templates' + name
      end
  end
end
