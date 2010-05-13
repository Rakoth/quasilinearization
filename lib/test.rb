# encoding: utf-8
require File.join('.', File.dirname(__FILE__), 'main')

# x' = ax*exp(bt)
#dot_z = VectorFunction.new(:size => 3, :arg_size => 2) do |args|
#  t = args[0]
#  z_t = args[1][t]
#  [z_t[1] * z_t[0] * Math.exp(z_t[2] * t), 0, 0]
#end

#dot_z.derivative = lambda do |args|
#  t = args[0]
#  z_t = args[1][t]
#  [
#    [ 
#      z_t[1] * Math.exp(z_t[2] * t),
#      z_t[0] * Math.exp(z_t[2] * t),
#      z_t[1] * z_t[0] * t * Math.exp(z_t[2] * t)
#    ],
#    [ 0, 0, 0 ],
#    [ 0, 0, 0 ]
#  ]
#end

#range = 0..1

#z_trajectory = VectorFunction.new(:size => 3, :arg_size => 1) do |args|
#  t = args[0]
#  [4*t + 1, 2, 3]
#end

#observes = {
#  :time => [0, 0.5, 1.0],
#  :values => [Vector[1.0], Vector[1.913], Vector[5.575]]
#}

#z_trajectory = VectorFunction.new(:size => 3, :arg_size => 1) do |args|
#  t = args[0]
#  [Math.exp(-2*(Math.exp(t) - 1)), -3, 0]
#end

#observes = {
#  :time => [0, 0.5, 1.0],
#  :values => [Vector[1.0], Vector[0.2732], Vector[0.0322]]
#}

#require File.join('.', File.dirname(__FILE__), 'examples', 'rickati')
require File.join('.', File.dirname(__FILE__), 'examples', 'rickati_many_params')
#require File.join('.', File.dirname(__FILE__), 'examples', 'linear_system')

trajectory = IterationTrajectorySeeker.new(EXAMPLE).find!
  
puts "FINDED: "
puts "#{trajectory.inspect(EXAMPLE[:range])}"

keys = [0, 0.25, 0.5, 0.75, 1.0]
keys = [0, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5]

datas = {}
errors = {}
EXAMPLE[:process_size].times do |i|
  datas["Исходная №#{i+1}"] = ORIGINAL_TRAJECTORY.to_a(keys).map{|val| val[i]}
  datas["Полученная №#{i+1}"] = trajectory.to_a(keys).map{|val| val[i]}
  errors["Координата №#{i+1}"] = (0...keys.size).map do |index|
    (datas["Исходная №#{i+1}"][index] - datas["Полученная №#{i+1}"][index]).abs
  end
end

Graphic.new :keys => keys, :datas => datas, :title => "Сравнение Траекторий", :line_width => 2
Graphic.new :keys => keys, :datas => errors, :title => "Ошибка"

#alpha, a, b = 2, 1, 1
#dot_x_function = VectorFunction.new(:size => 1, :arg_size => 2) do |t, x|
#  [b*t**alpha - a * x[0]**2]
#end

#result = RungeKutta.new(
#  :function => dot_x_function,
#  :range => 0..1,
#  :start_value => Vector[1]
#).solve

#puts [0, 0.4, 0.7, 1].map{|t| result[t]}

