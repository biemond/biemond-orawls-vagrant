module EasyType
  #
  # Contains a template helper method. 
  #
  module Template

    # @private
    def self.included(parent)
      parent.extend(Template)
    end
    ##
    #
    # This allows you to use an erb file. Just like in the normal Puppet classes. The file is searched
    # in the template directory on the same level as the ruby library path. For most puppet classes
    # this is eqal to the normal template path of a module
    # 
    # @example
    #  template 'create_tablespace.sql', binding
    #
    # @param [String] name this is the name of the template to be used
    # @param [Binding] context this is the binding to be used in the template
    #
    # @raise [ArgumentError] when the file doesn't exist
    # @return [String] interpreted ERB template
    #
    def template(name, context)
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

      # @private
      def path_name(dir, name)
        Pathname.new(dir).parent + 'templates' + name
      end
    end
end
