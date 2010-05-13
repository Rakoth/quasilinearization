require 'spec_helper'

describe MatrixFunction do
	before do
		@size = 3
		@it = MatrixFunction.new(:size => @size) { |args| [[0, 0, 0], [0, 0, 0], [0, 0, 0]] }
    @return_type = Matrix
	end

	it_should_behave_like "Functions"

	describe "evaluating result" do
		it "should raise an error if bad result obtained" do
			@it.instance_variable_set(:@proc, lambda{|args| [[]]})
			lambda{@it.at(0, 0, 0)}.should raise_exception(Function::UnexpectedResult)
		end

		it "should give correct result" do
			@it = MatrixFunction.new(:size => 2){|args| [[args[0] ** 2, args[1] ** 2], [0, 0]]}
			@it.at(0, 0).should == Matrix[[0, 0], [0, 0]]
			@it.at(1, 2).should == Matrix[[1, 4], [0, 0]]
			@it.at(4, -1).should == Matrix[[16, 1], [0, 0]]
		end
	end
end