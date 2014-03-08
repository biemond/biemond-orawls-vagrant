require 'spec_helper'
require 'easy_type/template'

describe EasyType::Template do
	include EasyType::Template

	let(:my_variable) {'my variable'}
	subject { template(file, binding)}

	MyTemplate = Struct.new(:content)


	context "a file does exist" do

		let(:file) { "puppet:///modules/easy_type/existing_test_template.txt.erb"}


		it "evaluates the template" do
			expect(self).to receive(:load_file).with('puppet:///modules/easy_type/existing_test_template.txt.erb').and_return(MyTemplate.new('template contains <%= my_variable %>'))
			expect(subject).to eq "template contains my variable"
		end
	end


	context "a file does not exist" do

		let(:file) { "puppet:///modules/easy_type/non_existing_file.txt"}

		it "raises an ArgumentError" do
			expect{subject}.to raise_error(ArgumentError)
		end
	end

end

