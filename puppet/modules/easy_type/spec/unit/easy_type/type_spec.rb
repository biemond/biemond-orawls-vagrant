require 'spec_helper'
require 'easy_type/type'
require 'easy_type/file_includer'

describe EasyType::Type do

	before do
		module Puppet
			newtype(:test) do
				include EasyType::Type
				newparam(:name) do
					isnamevar
				end
			end
		end

	end

	after do
		Puppet::Type.rmtype(:test)
	end

	subject { Puppet::Type::Test.new(:name => 'test') }

	describe ".on_create" do

		before do
			class Puppet::Type::Test
				on_create do
					"done"
				end
			end
		end

		it "adds a instance method on_create" do
			expect( subject.on_create).to eql('done')
		end
	end

	describe ".on_destroy" do

		before do
			class Puppet::Type::Test
				on_destroy do
					"done"
				end
			end
		end

		it "adds a instance method on_destroy" do
			expect( subject.on_destroy).to eql('done')
		end

	end


	describe ".on_modify" do

		before do
			class Puppet::Type::Test
				on_modify do
					"done"
				end
			end
		end

		it "adds a instance method on_modify" do
			expect( subject.on_modify).to eql('done')
		end

	end

	describe ".to_get_raw_resources" do

		before do
			class Puppet::Type::Test
				to_get_raw_resources do
					"done"
				end
			end
		end


		it "adds a class method get_raw_resources" do
			expect( Puppet::Type::Test.get_raw_resources).to eql('done')
		end

	end

	describe ".property & .parameter" do

		before do
			class Puppet::Type::Test
				include EasyType
				extend EasyType::FileIncluder
				property	:a_test
				parameter :b_test
			end
		end

		it "defines a property" do
			expect( defined?(Puppet::Type::Test::A_test)).to be_true
		end

		it "defines a parameter" do
			expect( defined?(Puppet::Type::Test::ParameterB_test)).to be_true
		end

	end


	describe ".group" do

		context "a group with invalid content" do
			subject do
				class Puppet::Type::Test
					include EasyType
					group do
						erronous_command
					end
				end
			end

			it "raises an error" do
				expect{subject}.to raise_error(NameError)
			end
		end


		context "a group with valid content" do
			before do
				class Puppet::Type::Test
					include EasyType
					group(:test) do
						parameter	:a_test
						property 	:b_test
					end
				end
			end

			it "defines a parameter" do
				expect( defined?(Puppet::Type::Test::ParameterB_test)).to be_true
			end

			it "defines a property" do
				expect( defined?(Puppet::Type::Test::A_test)).to be_true
			end

			it "defines a type" do
				expect( Puppet::Type::Test.groups).to include(:test)
			end 

			it "the group to include the parameter" do
				expect( Puppet::Type::Test.groups.include_property?(Puppet::Type::Test::ParameterB_test)).to be_true
			end 

			it "the group to include the property" do
				expect( Puppet::Type::Test.groups.include_property?(Puppet::Type::Test::A_test)).to be_true
			end 


		end
	end
end

