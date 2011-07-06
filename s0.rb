vsync = UICheckBox.new("Enable vsync").tap do |v|
  v.layout_data = anchor(frame.content_panel, 5, -5, 
                         Alignment::TOP_LEFT)
  v.selectable = true
  v.add_action_listener { |e| canvas.vsync_enabled = vsync.selected? }
end
