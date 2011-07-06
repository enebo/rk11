collide = UICheckBox.new("Enable ball collision").tap do |c|
  c.layout_data = anchor(vsync, 0, -5)
  c.selectable = true
  c.selected = !@skip_ball_collide
  c.add_action_listener { |e| @skip_ball_collide = !collide.selected? }
end
 
