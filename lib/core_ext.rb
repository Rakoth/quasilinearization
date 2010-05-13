class Vector
  def / number
    self * (1.0 / number)
  end
end

class Float
  def round_to power
    multiply = 10.0 ** power
    (self * multiply).round / multiply
  end
end
