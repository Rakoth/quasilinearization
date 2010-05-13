# Тестовый пример - линейная система
# x_1' = -a*x_2
# x_2' = b*x_1*t
# a = 2, b = -3
# n = 2, m = 2
# таблица наблюдений:
# t   | 0.0 |       1.0 |
# x_1 | 1.0 | -0.935311 |
# x_2 | 1.0 |  1.370364 |
# начальная траектория z(t) = [-2*t + 1, 1, 1, -1]
# Количество шагов: 6
# графики 13_04_17
dot_z = VectorFunction.new(:size => 4, :arg_size => 2) do |args|
  t, z = args
  z_t = z[t]
  [-z_t[2] * z_t[1], z_t[3]*z_t[0]*t, 0, 0]
end

dot_z.derivative = lambda do |args|
  t, z = args
  z_t = z[t]
  [
    [0, -z_t[2], -z_t[1], 0],
    [z_t[3]*t, 0, 0, z_t[0]*t],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
  ]
end

z_trajectory = VectorFunction.new(:size => 4, :arg_size => 1) do |args|
  t = args[0]
  [-2*t + 1, 1, 1, -1]
end

observes = {
  :time => [0.0, 1.0],
  :values => [
    Vector[1.0, 1.0],
    Vector[-0.935311, 1.370364]
  ]
}

range = 0..1.5

function = VectorFunction.new(:size => 2, :arg_size => 2) do |args|
  t, x = args
  a = 2
  b = -3
  [- a * x[1], b * x[0] * t]
end
ORIGINAL_TRAJECTORY = RungeKutta.new(
  :function => function,
  :range => range,
  :start_value => Vector[1, 1]
).solve

EXAMPLE = {
  :process_size => 2,
  :params_size => 2,
  :function_with_dirivative => dot_z,
  :range => range,
  :start_trajectory => z_trajectory,
  :observes => observes
}
