hud.layout do
  frame(:bubbles, "Bubbles") do
    pack 500, 300
    #...
  end
  frame(:config, "Config") do
    update_minimum_size_from_contents
    pack 320, 240
    content_panel.layout = anchor
    check_box(:vsync, "Enabled VSync") do
      anchor_from :top_left, previous, :top_left, 5, -5
      selectable = true
      add_action_listener { |e| canvas.vsync_enabled = selected? }
    end
    #...
  end
end
