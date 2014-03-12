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
      ERB.new(load_file(name).content).result(context)
    end

  private
    def load_file(name)
      # Somehow there is no consistent way to determine what terminus to user. So we switch to a
      # trial and error method. First we start withe the default. And if it doesn't work, we try the
      # other ones
      template_file = load_file_with_default_terminus(name)
      rescue 
      ensure
        template_file = load_file_with_other_termini(name) unless template_file
        raise ArgumentError, "Could not find template '#{name}'" unless template_file
        template_file
    end

    def load_file_with_default_terminus(name)
      Puppet::FileServing::Content.indirection.find(name)
    end

    def load_file_with_other_termini
      termini_to_try = [:rest, :file_server] - Puppet[:default_file_terminus]
      current_terminus = Puppet[:default_file_terminus]
      termini_to_try.each do | terminus|
        template_file = with_terminus(terminus) do
          Puppet::FileServing::Content.indirection.find(name)
        end
        return template_file if template_file
      end
      nil
    end

    def with_terminus(terminus)
      old_terminus = Puppet[:default_file_terminus]
      Puppet[:default_file_terminus] = terminus
      value = yield
      Puppet[:default_file_terminus] = old_terminus
      value
    end
  end

end
