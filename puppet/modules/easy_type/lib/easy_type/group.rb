module EasyType
  class Group
  	def initialize
  		@content = {}
  	end

  	def contents_for(group_name)
			@content.fetch(group_name) { fail "easy_type: No group defined with name #{group_name}"}
  	end

  	def add(group_name, parameter_or_property)
  		group = ensure_group(group_name)
	  	group << parameter_or_property
	  	group
  	end

    def group_for(parameter_or_property)
      @content.each_pair do | key, value|
        return key if value.include?(parameter_or_property)
      end
      fail "easy_type: #{parameter_or_property} not found in any group"
    end

  	def include?(group_name)
  		@content.keys.include?(group_name)
  	end

 		def include_property?(parameter_or_property)
  		@content.values.flatten.include?(parameter_or_property)
  	end

  	private

	  def ensure_group(group_name)
	  	@content.fetch(group_name) { @content[group_name] = [] }
	  end


  end
end
