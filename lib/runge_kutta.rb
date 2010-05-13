require "matrix"
class RungeKutta
  RANG = 4
  METHOD_PARAMS = [
    1.0 / 6,
    1.0 / 3,
    1.0 / 3,
    1.0 / 6
  ]
  EPSILON = 0.00001
  DEFAULT_STEP = 0.01
  
  #
  # Класс для численного решения дифференциальных уравнений вида <code>x' = f(t, x)</code>
  #
  # Где:
  # * <tt> t - числовой аргумент функции                             </tt>
  # * <tt> x - векторный аргумент функции                            </tt>
  # * <tt> f - дает на выходе вектор, той же размерности, что и +x+. </tt>
  #
  #
  # Параметры инициализации:
  # * <tt> _function_ - объект класса Function, представляющий правую часть уравнения </tt>
  # * <tt> _range_ - отрезок, на котором необходимо узнать значение решения           </tt>
  # * <tt> _start_value_ - начальные данные задачи Коши                               </tt>
  # * <tt> _step_ = DEFAULT_STEP - заданный шаг интегрирования                        </tt>
  # * <tt> _precision_ = EPSILON - заданная точность решения (не используется)        </tt>
  # 
  # Пример использования:
  #
  # Для решения уравнения x' = 3x
  #
  #    func = VectorFunction.new(:size => 1, :arg_size => 2) do |args|
  #      time = args[0]
  #      variable = args[1]
  #      [3 * variable[0]]
  #    end
  #    print RungeKutta.new(
  #      :function => func,
  #      :range => 0.1..0.2,
  #      :start_value => Vector[1]
  #    ).solve()
  #
  def initialize options = {}
    @func = options[:function]
    @range = options[:range]
    @start_value = options[:start_value]
    @precision = options[:precision] || EPSILON
    @step = options[:step] || DEFAULT_STEP
  end
  
  def solve
    self.current_value = start_value
    @range.step(step) do |arg|
      self.current_argument = arg
      result[current_argument] = current_value
      break if current_argument == @range.end
      self.current_value += increment
      expire_stages_cache!
    end
    result
  end
  
  protected
  
  attr_reader :func, :step, :start_value
  attr_accessor :current_argument, :current_value
  
  def zero_element
    @zero_element ||= start_value * 0
  end
  
  def result
    @result ||= RungeKuttaResult.new(step)
  end
  
  def stages
    @stages ||= []
  end
  
  def increment
   (0...RANG).inject(zero_element){|sum, stage_index| sum + stage(stage_index)} * step
  end
  
  def stage index
    stages[index] ||= stages_expressions(index) * METHOD_PARAMS[index]
  end
  
  def stages_expressions stage_index
    case stage_index
      when 0
      func[current_argument, current_value]
      when 1, 2
      func[
        current_argument + step / 2,
        current_value + stage(stage_index - 1) * (step / 2)
      ]
      when 3
      func[current_argument + step, current_value + stage(2) * step]
    end
  end
  
  def expire_stages_cache!
    @stages = nil
  end
  
  class RungeKuttaResult
    def initialize step
      @round_power = Math.log10(1 / step).to_i
    end
    
    def []= argument, value
      values[caste_arg(argument)] = value
    end
    
    def [] argument
      value = values[caste_arg(argument)]
      if value.nil?
        raise ArgumentError.new("Null value for argument: #{caste_arg(argument)}(#{argument})")
      end
      value 
    end
    
    def values
      @values ||= {}
    end
    
    def caste_arg arg
     (arg * 10**@round_power).round
    end
    
    def inspect
      map_every_key{|arg| "#{arg}: #{values[arg]}"}
    end
    
    def to_a keys = nil
      keys.nil? ? map_every_key{|arg| values[arg]} : keys.sort.map{|k| self[k]}
    end
    
    def map_every_key each = 100, &block
      values.keys.sort.select{|k| 0 == k % range}.map &block
    end
  end
end
