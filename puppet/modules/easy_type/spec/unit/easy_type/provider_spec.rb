#!/usr/bin/env ruby

require 'spec_helper'
require 'easy_type'
require 'puppet'



module Puppet

  newtype(:test) do
  	include EasyType

    to_get_raw_resources do
    	[
    		{:name => 'my_first_name'	, :my_property => 'my first property'},
    		{:name => 'my_second_name', :my_property => 'my second property'}
    	]
    end

    ensurable

		set_command(:do_command)

    on_create do
    	"on_create"
    end

    on_modify do
    	"on_modify"
    end

    on_destroy do
    	"on_destroy"
    end

    newparam(:name) do
	  	include EasyType
      include EasyType::Validators::Name

      isnamevar

      to_translate_to_resource do | raw_resource|
      	raw_resource[:name]
      end

      on_apply do
      	"name attribute applied"
      end

    end

    newproperty(:my_property) do
	  	include EasyType

      to_translate_to_resource do | raw_resource|
      	raw_resource[:my_property]
      end

      on_apply do |builder| 
      	"my_property applied"
      end

    end

  	provide(:simple) do
  		include EasyType::Provider
		  mk_resource_methods

			def do_command(line, options)
				"do command #{line}"
			end
  	end



  end
end


describe Puppet::Type.type(:test) do


	describe ".instances" do

		it "calls get_raw_resources on the type" do
			expect(described_class).to receive(:get_raw_resources).and_call_original
			described_class.instances
		end

		describe "traversing type information" do
			it "calls map_raw_to_resource for every parameter when to_map_raw_to_resource set " do
				expect(Puppet::Type::Test::ParameterName).to receive(:translate_to_resource).exactly(2).times.and_call_original
				described_class.instances
			end

			it "calls map_raw_to_resource for every property when to_map_raw_to_resource set " do
				expect(Puppet::Type::Test::My_property).to receive(:translate_to_resource).exactly(2).times.and_call_original
				described_class.instances
			end
		end

		it "returns valid puppet resources" do
			expect(described_class.instances[0].class).to eq Puppet::Type::Test 
		end

		it "returns all specfied valid puppet resources" do
			expect(described_class.instances.length).to eq 2 
		end
	end

	describe "basic resource methods" do

		let(:resource) { Puppet::Type::Test.new(:name => 'a_test', :ensure => 'present', :my_property => 'my stuff')}

		describe "create" do

			it "calls on_create on the type" do
				expect_any_instance_of(described_class).to receive(:on_create).and_call_original
				resource.provider.create
			end

			it "calls on_apply on the properties" do
				expect_any_instance_of(Puppet::Type::Test::My_property).to receive(:on_apply).and_call_original
				resource.provider.create
			end

		end

		describe "destroy" do

			it "calls on_destroy on the type" do
				expect_any_instance_of(described_class).to receive(:on_destroy).and_call_original
				resource.provider.destroy
			end
		end

		describe "modify" do

			it "calls on_update on the type" do
				resource.provider.my_property = "changed"
				expect_any_instance_of(described_class).to receive(:on_modify).and_call_original
				resource.provider.flush
			end

			it "calls on_apply on the properties" do
				resource.provider.my_property = "changed"
				expect_any_instance_of(Puppet::Type::Test::My_property).to receive(:on_apply).and_call_original
				resource.provider.flush
			end

			it "executes the command" do
				resource.provider.my_property = "changed"
				expect(resource.provider).to receive(:do_command).and_call_original
				resource.provider.flush
			end


		end


	end


end

