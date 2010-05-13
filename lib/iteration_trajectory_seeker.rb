class IterationTrajectorySeeker
  MAX_ITERATIONS = 10
  
  def initialize options = {}
    @process_size = options[:process_size]
    @params_size = options[:params_size]
    @function = options[:function_with_dirivative]
    @range = options[:range]
    @start_trajectory = options[:start_trajectory]
    @current_trajectory = @start_trajectory
    @observes = options[:observes]
  end
  
  def find!
    safe_counter = 0
    begin
      @previous_trajectory = @current_trajectory
      @current_trajectory = next_trajectory
      
      puts "PARAMS: #{extract_params_values(@current_trajectory)}"
      
      safe_counter += 1
    end until precision_fit? or MAX_ITERATIONS < safe_counter
    @current_trajectory
  end
  
  protected
  
  def next_trajectory
    w = w_matrix_function
    s = s_vector_function
    c = c_vector_constant(w, s)
    VectorFunction.new(trajectory_sizes) do |args|
      t = args[0]
      w[t] * c + s[t]
    end
  end
  
  def precision_fit?
    current_params = extract_params_values(@current_trajectory)
    previous_params = extract_params_values(@previous_trajectory)
    (current_params - previous_params).r < 0.0001
  end
  
  def extract_params_values trajectory
    Vector[* trajectory[@observes[:time][0]].to_a[(@process_size)..-1]]
  end
  
  def w_matrix_function
    RungeKutta.new(
      :function => w_equation,
      :range => @range,
      :start_value => Matrix.identity(trajectory_sizes[:size])
    ).solve
  end
  
  # W'(t) = dF()/dz * W(t)
  def w_equation
    c_t = @current_trajectory
    MatrixFunction.new(equation_sizes) do |args|
      t, w = args
      @function.derivative[t, c_t] * w
    end
  end
  
  def s_vector_function
    RungeKutta.new(
      :function => s_equation,
      :range => @range,
      :start_value => Vector[*([0] * trajectory_sizes[:size])]
    ).solve
  end
  
  # S'(t) = dF()/dz * S(t) + (F(z_0, t) - dF()/dz * z_0)
  def s_equation
    c_t = @current_trajectory
    VectorFunction.new(equation_sizes) do |args|
      t, s = args
      temp_derivative = @function.derivative[t, c_t]
      temp_derivative * s + @function[t, c_t] - temp_derivative * c_t[t]
    end
  end
  
  # arg(min(sum(y_i - x_i)^2))
  def c_vector_constant(w_function, s_function)
    h_w_matrix = build_h_w_matrix(w_function)
    puts h_w_matrix unless h_w_matrix.regular?
    h_w_matrix.inverse * build_y_minus_s_vector(s_function)
    #Vector[0, 1, 1]
  end
  
  def build_h_w_matrix(w_function)
    rows = []
    ((@process_size + @params_size) / @process_size).times do |i|
      rows += (h_matrix * w_function[@observes[:time][i]]).to_a
    end
    Matrix[*rows]
  end
  
  def build_y_minus_s_vector s_function
    components = []
    ((@process_size + @params_size) / @process_size).times do |i|
      components += (
        @observes[:values][i] - h_matrix * s_function[@observes[:time][i]]
      ).to_a
    end
    Vector[*components]
  end
  
  def h_matrix
    @h_matrix ||= Matrix[
      * Matrix.I(@process_size).to_a.map{|row| row + [0] * @params_size}
    ]
  end
  
  def trajectory_sizes
    @trajectory_sizes ||= sizes(@start_trajectory)
  end
  
  def equation_sizes
    @equation_sizes ||= sizes(@function)
  end
  
  def sizes function
    {
      :size => function.size,
      :arg_size => function.arg_size
    }
  end
end

