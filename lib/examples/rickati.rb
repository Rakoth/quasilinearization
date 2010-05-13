# Тестовый пример - специальное уравнение Рикатти
# x' = t^2 - ax^2
# n = 1, m = 1
# a = 1
# таблица наблюдений:
# t | 0.0 | 0.4310 |
# x | 1.0 | 0.7217 |
# начальная траектория z(t) = [0.69 * t^2 - 0.94 * t + 1, 4]
# Количество шагов: 3
# графики 13_02_52
dot_z = VectorFunction.new(:size => 2, :arg_size => 2) do |args|
  t, z = args
  z_t = z[t]
  [z_t[1] * t**2 - 1 * z_t[0]**2, 0]
end

dot_z.derivative = lambda do |args|
  t, z = args
  z_t = z[t]
  [
    [ -2*z_t[0], t**2 ],
    [ 0, 0 ]
  ]
end

z_trajectory = VectorFunction.new(:size => 2, :arg_size => 1) do |args|
  t = args[0]
  [0.69 * (t ** 2) - 0.94 * t + 1, 4]
end

observes = {
  :time => [0.0, 0.4310],
  :values => [
    Vector[1.0],
    Vector[0.7217]
  ]
}

range = 0..1

function = VectorFunction.new(:size => 1, :arg_size => 2) do |args|
  t, x = args
  a = 1
  [a * t**2 - x[0]**2]
end
ORIGINAL_TRAJECTORY = RungeKutta.new(
  :function => function,
  :range => range,
  :start_value => Vector[1]
).solve

EXAMPLE = {
  :process_size => 1,
  :params_size => 1,
  :function_with_dirivative => dot_z,
  :range => range,
  :start_trajectory => z_trajectory,
  :observes => observes
}
