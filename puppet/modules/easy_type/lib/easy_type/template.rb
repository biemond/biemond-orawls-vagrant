require 'puppet/file_serving'
require 'puppet/file_serving/content'

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
    #  template 'puppet:///modules/my_module_name/create_tablespace.sql.erb', binding
    #
    # @param [String] name this is the name of the template to be used. 
    # @param [Binding] context this is the binding to be used in the template
    #
    # @raise [ArgumentError] when the file doesn't exist
    # @return [String] interpreted ERB template
    #
    def template(name, context)
      template_file = Puppet::FileServing::Content.indirection.find(name)
      raise Puppet::ParseError, "Could not find template '#{name}'" unless template_file
      ERB.new(template_file.content).result(context)
    end
  end

end
