module Utils
  module PythonReader
    def python_file(name)
      full_name = get_file(name)
      raise ArgumentError, "file #{name} not found" unless full_name
      eval(IO.read(full_name))
    end

    private
      # @private
      def get_file(name)
        name = name + '.rb' unless name =~ /\.py$/
        path = $LOAD_PATH.find { |dir| File.exist?(File.join(dir, name)) }
        path and File.join(path, name)
      end
    end
  end
end
