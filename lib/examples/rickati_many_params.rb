# Тестовый пример - специальное уравнение Рикатти
# x' = bt^2 - ax^2
# n = 1, m = 2
# a = 3, b = -1
# таблица наблюдений:
# t | 0.0 | 0.4310 |    1.0 |
# x | 1.0 | 0.7217 | 0.0018 |
# начальная траектория z(t) = [0.6136 * (t ** 2) - 1,5302 * t + 0,9670, 0, 3]
# Количество шагов: 5
# графики 13_04_23
dot_z = VectorFunction.new(:size => 3, :arg_size => 2) do |args|
  t, z = args
  z_t = z[t]
  [z_t[2] * t**2 - z_t[1] * z_t[0]**2, 0, 0]
end

dot_z.derivative = lambda do |args|
  t, z = args
  z_t = z[t]
  [
    [ -2*z_t[0]*z_t[1], -z_t[0]**2, t**2 ],
    [ 0, 0, 0 ],
    [ 0, 0, 0 ]
  ]
end

z_trajectory = VectorFunction.new(:size => 3, :arg_size => 1) do |args|
  t = args[0]
  [0.6136 * (t ** 2) - 1.5302 * t + 0.9670, 0, 3]
end

observes = {
  :time => [0.0, 0.4310, 1.0],
  :values => [
    Vector[1.0],
    Vector[0.4160],
    Vector[0.0018]
  ]
}

range = 0..1.5

function = VectorFunction.new(:size => 1, :arg_size => 2) do |args|
  t, x = args
  a = 3
  b = -1
  [b * t**2 - a * x[0]**2]
end
ORIGINAL_TRAJECTORY = RungeKutta.new(
  :function => function,
  :range => range,
  :start_value => Vector[1]
).solve

EXAMPLE = {
  :process_size => 1,
  :params_size => 2,
  :function_with_dirivative => dot_z,
  :range => range,
  :start_trajectory => z_trajectory,
  :observes => observes
}
