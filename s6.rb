java_import java.util.ArrayList

class ArrayList
  def <<(element)
    add element
    self
  end
end

a = ArrayList.new
a << 1 << 2
puts a # [1, 2]
      
