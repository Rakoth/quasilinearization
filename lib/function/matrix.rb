class MatrixFunction < Function

protected

	def valid_result? result
		result.square? and super(result.row(0))
	end

	def typed_result result
		result.is_a?(Matrix) ? result : Matrix[*result]
	end
end
