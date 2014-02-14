#!/usr/bin/env ruby

require 'spec_helper'
require 'easy_type/helpers.rb'


describe "convert_csv_data_to_hash" do
	include EasyType::Helpers

	context "a valid comma separated string with header" do
		subject { "col1,col2,col3\nvalue1,value2,value3"}

		it "returns an Array of Hashes" do
			expect(convert_csv_data_to_hash(subject)).to \
					eq [{'col1' => 'value1', 'col2' => 'value2', 'col3' => 'value3'}]
		end
	end

	context "a valid comma separated string with header and a marker line" do
		subject { "col1,col2,col3\n--------\nvalue1,value2,value3"}

		it "returns an Array of Hashes" do
			expect(convert_csv_data_to_hash(subject)).to \
					eq [{'col1' => 'value1', 'col2' => 'value2', 'col3' => 'value3'}]
		end
	end


	context "a valid comma separated string without header" do
		subject { "value1,value2,value3\n"}

		context "called with header specified" do
			it "returns an Array of Hashes" do
				expect(convert_csv_data_to_hash(subject, ['col1', 'col2', 'col3'])).to \
						eq [{'col1' => 'value1', 'col2' => 'value2', 'col3' => 'value3'}]
			end
		end

	end

end

describe EasyType::Helpers::InstancesResults do
	include EasyType::Helpers

	let(:the_hash) {EasyType::Helpers::InstancesResults[:known_key,10]}
	subject {the_hash.column_data(key)}

	describe "#column_data" do
		context "a valid column name given" do
			let(:key) {:known_key}

			it "returns the content" do
				expect(subject).to eq 10
			end

		end

		context "an invalid column name given" do
			let(:key) {:unknown_key}

			it "raises an error" do
				expect{subject}.to raise_error(RuntimeError)
			end

	end

	end

end