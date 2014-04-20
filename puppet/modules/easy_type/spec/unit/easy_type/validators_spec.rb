require 'spec_helper'
require 'easy_type/validators'

describe EasyType::Validators::Name do
	include EasyType::Validators::Name

	it "does nothing on a valid name string" do
		expect(unsafe_validate('bert')).to eql nil
	end

	it "raises ArgumentError on empty string" do
		expect{unsafe_validate('')}.to raise_error(Puppet::Error)
	end

	it "raises ArgumentError on string with whitespace" do
		expect{unsafe_validate('bert hajee')}.to raise_error(Puppet::Error)
	end

end

