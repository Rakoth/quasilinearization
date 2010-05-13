require 'spec_helper'

shared_examples_for "Functions" do
	it "should can take arg as list" do
		lambda{@it.at(0, 0, 0)}.should_not raise_exception
	end

	it "should can take arg as array" do
		lambda{@it.at([0, 0, 0])}.should_not raise_exception
	end

	it "should can take arg as Vector" do
		lambda{@it.at(Vector[0, 0, 0])}.should_not raise_exception
	end

	it "should raise an error if bad argument given" do
		lambda{@it.at(0)}.should raise_exception(Function::UnexpectedArgument)
  end

  it "should return instance of correct type" do
    @it.at(1, 2, 3).should be_an_instance_of(@return_type)
    @it.at(0, 0, 0).should be_an_instance_of(@return_type)
  end
end

describe VectorFunction do
	before do
		@size = 3
		@it = VectorFunction.new(:size => @size) do |vector|
			[0, 0, 0]
    end
    @return_type = Vector
	end

	it_should_behave_like "Functions"

	describe "evaluating result" do
		it "should raise an error if bad result obtained" do
			@it.instance_variable_set(:@proc, lambda{|*args|[]})
			lambda{@it.at(0, 0, 0)}.should raise_exception(Function::UnexpectedResult)
		end

		it "should give correct result" do
			@it = VectorFunction.new(:size => 2){|arg| [arg[0] ** 2, arg[1] ** 2]}
			@it.at(0, 0).should == Vector[0, 0]
			@it.at(1, 2).should == Vector[1, 4]
			@it.at(4, -1).should == Vector[16, 1]
		end
	end
	
	shared_examples_for "correct derivative" do
		it "should create a MatrixFunction derivetive from given block" do
			@it.derivative.should be_an_instance_of(MatrixFunction)
		end

		it "should set correct size for derivative" do
			@it.derivative.size.should == @it.size
			@it.derivative.arg_size.should == @it.arg_size
		end
	end

	describe "set derivative in initializer" do
		before do
			@it = VectorFunction.new(:size => 2, :derivative => lambda{[[0, 0], [0, 0]]}){[0, 0]}
		end

		it_should_behave_like "correct derivative"
	end

	describe "setting derivetive with accessor" do
		before do
			@it = VectorFunction.new(:size => 2){[0, 0]}
			@it.derivative = lambda{|arg| [[0, 0], [0, 0]]}
		end

		it_should_behave_like "correct derivative"
	end
end