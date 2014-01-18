module EasyType
  #
  # EasyType is a flushable provider. To use this provider, you have to 
  # add certain information to the type definition.
  # You MUST define following attributes on the type
  #
  #  on_create do
  #    "create user #{self[:name]}"
  #  end
  #
  #  on_modify do
  #    "alter user #{self[:name]}"
  #  end
  #
  #  on_destroy do
  #    "drop user #{self[:name]}"
  #  end
  #
  # for all properties you MUST add
  # 
  #  on_apply do
  #   "identified by #{resource[:password]}"
  #  end
  module Provider

    attr_reader :property_flush, :property_hash

    def self.included(parent)
      parent.extend(ClassMethods)
    end

    def initialize(value={})
      super(value)
      @property_flush = {}
    end

    def exists?
      @property_hash[:ensure] == :present
    end

    def create
      @property_flush = @resource
      @property_hash[:ensure] = :present
      command = build_from_type(resource.on_create)
      command.execute
      @property_flush = {}
    end

    def destroy
      command = CommandBuilder.new(self, resource.command, resource.on_destroy)
      command.execute
      @property_hash.clear
      @property_flush = {}
    end

    def flush
      if @property_flush && @property_flush != {}
        command = build_from_type(resource.on_modify)
        command.execute
      end
    end

    private
    def build_from_type(line)
      command_builder = CommandBuilder.new(self, resource.command, line)
      resource.properties.each do | prop |
        command_builder << "#{prop.on_apply command_builder} " if should_be_in_command(prop)
      end
      command_builder
    end

    ##
    # Should be in command if the property has defined an apply command
    # and when it is modified e.g. in de @property_flush
    #
    def should_be_in_command(property)
      defined?(property.on_apply) && @property_flush[property.name]
    end

    module ClassMethods
      def mk_resource_methods
        attributes = [resource_type.validproperties, resource_type.parameters].flatten
        raise Puppet::Error, 'no parameters or properties defined. Probably an error' if attributes == [:provider]
        attributes.each do |attr|
          attr = attr.intern
          next if attr == :name
          define_method(attr) do
            @property_hash[attr] || :absent
          end

          define_method(attr.to_s + "=") do |value|
            @property_flush[attr] = value
          end
        end
      end

      def instances
        fail("information: to_get_raw_resources not defined on type #{resource_type.name}") unless defined?(resource_type.get_raw_resources)
        raw_resources = resource_type.get_raw_resources
        raw_resources.collect do |raw_resource|
          map_raw_to_resource(raw_resource)
        end
      end


      def prefetch(resources)
        objects = instances
        resources.keys.each do |name|
          if provider = objects.find{ |object| object.name == name } 
            resources[name].provider = provider
          end
        end
      end

    private
      def map_raw_to_resource(raw_resource)
        resource = {}
        non_meta_parameter_classes.each do | parameter_class |
          if defined?(parameter_class.translate_to_resource)  
            resource[parameter_class.name] = parameter_class.translate_to_resource(raw_resource)
          end
        end
        resource[:ensure] = :present
        new(resource)
      end

      def non_meta_parameter_classes
        resource_type.properties + non_meta_parameters.collect {|param| resource_type.paramclass(param)}
      end

      def non_meta_parameters
        resource_type.parameters - resource_type.metaparams
      end

    end
  end

end