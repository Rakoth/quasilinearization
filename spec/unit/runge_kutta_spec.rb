require 'spec_helper'

describe RungeKutta do
	describe "solve sample 1" do
		before do
			function = VectorFunction.new(:size => 1, :arg_size => 2) do |arg|
				[3 * arg[1][0]]
			end
			@it = RungeKutta.new(
				:function => function,
				:range => 0.0..0.1,
				:start_value => Vector[1.0]
			)
		end

		it "should solve an equation" do
			@it.solve[0.1][0].should be_close(1 * Math.exp(3 * 0.1), 0.005)
		end
	end

	describe "solve sample 1" do
		before do
			function = VectorFunction.new(:size => 1, :arg_size => 2) do |arg|
				[2 / arg[1][0]]
			end
			@it = RungeKutta.new(
				:function => function,
				:range => 0.0..1.0,
				:start_value => Vector[1.0]
			)
		end

		it "should solve an equation" do
			@it.solve[1.0][0].should be_close(Math.sqrt(4 * 1.0 + 1), 0.005)
		end
	end
end
