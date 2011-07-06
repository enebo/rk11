# Add Frame for balls
@ballFrame = UIFrame.new("Bubbles").tap do |f|
  f.updateMinimumSizeFromContents
  f.update_minimum_size_from_contents

  f.setResizeable(false)
  f.resizeable = false

  f.isResizeable # true or false
  f.resizeable?

  width = f.getWidth
  width = f.width
end
