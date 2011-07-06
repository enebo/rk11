java_import java.util.ArrayList

class MyArray < ArrayList
  def size
    0  # WHOA!!!!!
  end
end

a = MyArray.new
a.add 1
p a.size #> 0
