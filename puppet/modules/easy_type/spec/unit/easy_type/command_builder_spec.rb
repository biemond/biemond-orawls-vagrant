#!/usr/bin/env ruby

require 'spec_helper'
require 'easy_type/command_builder'


describe EasyType::CommandBuilder do

	describe ".new" do

		context "do options passed" do
			subject {described_class.new(self, :command) }

			it "sets the command" do
				expect(subject.command).to eq(:command)
			end
		end

		context "options passed" do
			subject {described_class.new(self, :command, '', :option_a => 1, :option_b => true) }

			it "sets the command" do
				expect(subject.command).to eq(:command)
			end

			it "sets the options" do
				expect(subject.options).to eq({:option_a => 1, :option_b => true})
			end
		end

	end


	describe "#<<(parameter)" do

		let(:command) {described_class.new(self, :command, 'line')}
		subject {command << 'appended'}

		it "appends the parameter to the existing line" do
			expect(subject.line).to eq('line appended')
		end
	end


	describe "#before" do

		let(:command) {described_class.new(self, :command)}
		subject {command.before('before')}

		it "sets the before command" do
			expect(subject.before).to eq(['before'])
		end
	end



	describe "#after" do

		let(:command) {described_class.new(self, :command)}
		subject {command.after('after')}

		it "sets the after command" do
			expect(subject.after).to eq(['after'])
		end
	end

	describe "#execute" do

		before do
			def dummy_command(value, options)
				"dummy command executed with #{value}"
			end
		end

		let(:command) {described_class.new(self, :dummy_command, 'hallo')}
		subject {command.execute}


		context "no before & no after set" do

			it "executes the command with the line" do
				expect(subject).to eql('dummy command executed with hallo')
			end

			it "no before results set" do
				subject
				expect(command.before_results).to be_empty
			end

			it "no after results set" do
				subject
				expect(command.after_results).to be_empty
			end

		end

		context "with before & with after set" do
			before do
				command.after('after')
				command.before('before')
			end

			it "executes the command with the line" do
				expect(subject).to eql('dummy command executed with hallo')
			end

			it "before results set" do
				subject
				expect(command.before_results).to eql(['dummy command executed with before'])
			end

			it "after results set" do
				subject
				expect(command.after_results).to eql(['dummy command executed with after'])
			end


		end



	end

end