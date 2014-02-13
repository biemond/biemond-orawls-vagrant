require 'easy_type/version'
require 'easy_type/parameter'
require 'easy_type/type'
require 'easy_type/parameter'
require 'easy_type/mungers'
require 'easy_type/validators'
require 'easy_type/provider'
require 'easy_type/file_includer'
require 'easy_type/command_builder'
require 'easy_type/group'

module EasyType
	def self.included(parent)
		if parent.ancestors.include?(Puppet::Type)
			parent.send(:include, EasyType::Type)
		end
		if parent.ancestors.include?(Puppet::Parameter)
			parent.send(:include, EasyType::Parameter)
		end
		parent.extend EasyType::FileIncluder
	end
end
