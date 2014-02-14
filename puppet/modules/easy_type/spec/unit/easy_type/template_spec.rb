require 'spec_helper'
require 'easy_type/template'

describe EasyType::Template do
	include EasyType::Template

	let(:my_variable) {'my variable'}
	subject { template(file, binding)}


	context "a file does exist" do

		let(:file) { "existing_test_template.txt"}

		it "evaluates the template" do
			expect(subject).to eq "template contains my variable"
		end
	end


	context "a file does not exist" do

		let(:file) { "non_existing_file.txt"}

		it "raises an ArgumentError" do
			expect{subject}.to raise_error(ArgumentError)
		end
	end

end

