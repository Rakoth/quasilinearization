class Function
  class UnexpectedArgument < ArgumentError; end
  class UnexpectedResult < StandardError; end

  attr_reader :size, :arg_size

  def initialize options = {}, &block
    @size = options[:size]
    @arg_size = options[:arg_size] || options[:size]
    @proc = block
  end

  def at *args
    arg = typed_argument(args)
    raise UnexpectedArgument unless valid_argument?(arg)
    result = eval_result(arg)
    raise UnexpectedResult unless valid_result?(result)
    return result
  end
  alias_method :[], :at

  def inspect range, step = 0.1
    results = []
    range.step(step) do |arg|
      formatted_arg = arg.to_s[/\d+\.\d{1,2}/]
      results << "#{formatted_arg}: #{at(arg)}"
    end
    results.join("\n")
  end

protected

  def eval_result arg
    typed_result @proc.call(arg)
  end

  def valid_argument? args
    args.size == @arg_size
  end

  def valid_result? result
    result.size == @size
  end

  def typed_argument args
    case args.first
    when Vector
      args.first.to_a
    when Array
      args.first
    else
      args
    end
  end

  def typed_result result
    raise NotImplemented
  end
end
