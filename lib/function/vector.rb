class VectorFunction < Function
  def initialize options = {}, &block
    derivative = options.delete(:derivative)
    super(options, &block)
    self.derivative = derivative unless derivative.nil?
  end

  attr_reader :derivative

  def derivative= block_object
    @derivative = MatrixFunction.new(:size => size, :arg_size => arg_size, &block_object)
  end

  def to_a keys = nil
    keys.nil? ? [] : keys.sort.map{|k| at(k)}
  end

protected

  def typed_result result
    result.is_a?(Vector) ? result : Vector[*result]
  end
end
