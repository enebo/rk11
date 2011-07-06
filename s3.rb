class LeftMousePressed
  include ActionListener

  def initialize(app, collide_checkbox)
    @app, @collide_checkbox = app, collide_check
  end
  
  def actionPerformed(event)
    @app.skip_ball_collide = !@collide_check.selected?
  end
end

collide.addActionListener LeftMousePressed.new(app, collide)
