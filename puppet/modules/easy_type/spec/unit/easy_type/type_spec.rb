#!/usr/bin/env ruby

require 'spec_helper'
require 'easy_type/type'

describe EasyType::Type do

	before do
		class Test
			include EasyType::Type
		end
	end

	describe ".on_create" do

		before do
			class Test
				on_create do
					"done"
				end
			end
		end

		subject { Test.new}

		it "adds a instance method on_create" do
			expect( subject.on_create).to eql('done')
		end
	end

	describe ".on_destroy" do

		before do
			class Test
				on_destroy do
					"done"
				end
			end
		end

		subject { Test.new}

		it "adds a instance method on_destroy" do
			expect( subject.on_destroy).to eql('done')
		end

	end


	describe ".on_modify" do

		before do
			class Test
				on_modify do
					"done"
				end
			end
		end

		subject { Test.new}

		it "adds a instance method on_modify" do
			expect( subject.on_modify).to eql('done')
		end

	end

	describe ".to_get_raw_resources" do

		before do
			class Test
				to_get_raw_resources do
					"done"
				end
			end
		end


		it "adds a class method get_raw_resources" do
			expect( Test.get_raw_resources).to eql('done')
		end

	end


end

