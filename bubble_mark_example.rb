require 'java'

require 'dist/rk11.jar'
require 'lib/lwjgl/lwjgl.jar'
require 'lib/lwjgl/jinput.jar'
Dir[File.dirname(__FILE__) + 'lib/*.jar'].each { |jar_file| require jar_file }

java_import com.ardor3d.example.benchmark.ball.BallComponent
java_import com.ardor3d.example.ExampleBase2
java_import com.ardor3d.extension.ui.UICheckBox
java_import com.ardor3d.extension.ui.UIContainer
java_import com.ardor3d.extension.ui.UIFrame
java_import com.ardor3d.extension.ui.UIHud
java_import com.ardor3d.extension.ui.UILabel
java_import com.ardor3d.extension.ui.UIRadioButton
java_import com.ardor3d.extension.ui.backdrop.SolidBackdrop
java_import com.ardor3d.extension.ui.layout.AnchorLayout
java_import com.ardor3d.extension.ui.layout.AnchorLayoutData
java_import com.ardor3d.extension.ui.util.Alignment
java_import com.ardor3d.extension.ui.util.ButtonGroup
java_import com.ardor3d.extension.ui.util.SubTex
java_import com.ardor3d.image.Texture
java_import com.ardor3d.image.TextureStoreFormat
java_import com.ardor3d.math.ColorRGBA
java_import com.ardor3d.ui.text.BasicText
java_import com.ardor3d.util.TextureManager

# Re-open to fields accessible as methods
class ExampleBase2
  field_reader :_root => :root
  field_reader :_canvas => :canvas
  field_reader :_physicalLayer => :physical_layer
  field_reader :_logicalLayer => :logical_layer
end

# Re-open existing Java class to add (adorn) useful method).
class BallComponent 
  def collides?(other)
    ball.do_collide(other.ball)
  end
end

# The famous BubbleMark UI test, recreated using Ardor3D UI components.
class BubbleMarkUIExample < ExampleBase2
  BALL_SIZE = 52

  # Initialize our scene.
  def initExample
    @skip_ball_collide = false
    @frames = 0
    @balls = []
    @start_time = Time.now  # Use Ruby version when it is nicer

    canvas.title = "BubbleMarkUIExample"
    width = canvas.canvas_renderer.camera.width
    height = canvas.canvas_renderer.camera.height

    @hud = UIHud.new

    # Add Frame for balls
    @ballFrame = UIFrame.new("Bubbles").tap do |f|
      f.update_minimum_size_from_contents
      f.pack 500, 300
      f.layout
      f.resizeable = false     # short-hand-setter
      f.setHudXY 5, 5          # actual Java method name
      f.set_use_standin(false) # snake_case setter
    end

    @hud.add(@ballFrame)

    # Add background
    @ballFrame.content_panel.backdrop = SolidBackdrop.new(ColorRGBA::WHITE)

    # Add Frame for config
    @hud.add(build_config_frame(width, height))

    resetBalls(16)
    root.attachChild(@hud)

    @hud.setup_input(canvas, physical_layer, logical_layer)
  end

  def build_config_frame(width, height)
    frame = UIFrame.new("Config").tap do |f|
      f.updateMinimumSizeFromContents
      f.pack 320, 240
      f.use_standin = true
      f.setHudXY(width - f.local_component_width - 5, 
                 height - f.local_component_height - 5)
      f.content_panel.layout = AnchorLayout.new
    end

    vsync = UICheckBox.new("Enable vsync").tap do |v|
      v.layout_data = anchor(frame.content_panel, 5, -5, Alignment::TOP_LEFT)
      v.selectable = true
      v.add_action_listener { |event|  canvas.vsync_enabled = vsync.selected? }
    end

    collide = UICheckBox.new("Enable ball collision").tap do |c|
      c.layout_data = anchor(vsync, 0, -5)
      c.selectable = true
      c.selected = !@skip_ball_collide
      c.add_action_listener { |e| @skip_ball_collide = !collide.selected? }
    end

    balls_label = UILabel.new "# of balls:"
    balls_group = ButtonGroup.new
    balls16 = buildBallsButton(balls_group, balls_label, 16)
    balls32 = buildBallsButton(balls_group, balls16, 32)
    balls64 = buildBallsButton(balls_group, balls32, 64)
    balls128 = buildBallsButton(balls_group, balls64, 128)
    balls_label.layout_data = anchor(collide, 0, -15)
        
    [vsync, collide, balls_label, balls16, 
     balls32, balls64, balls128].each { |c| frame.content_panel.add c }

    frame.layout
    frame
  end

  def anchor(parent, x_offset, y_offset, parent_offset=Alignment::BOTTOM_LEFT)
    AnchorLayoutData.new(Alignment::TOP_LEFT, parent, parent_offset, 
                         x_offset, y_offset)
  end

  def buildBallsButton(group, previous, number)
    UIRadioButton.new(number.to_s).tap do |b|
      b.layout_data = anchor(previous, 0, -5)
      b.selectable = true
      b.selected = true
      b.addActionListener { |event| resetBalls(number) }
      b.group = group
    end
  end

  def updateLogicalLayer(timer)
    @hud.logical_layer.check_triggers timer.time_per_frame
  end

  def resetBalls(ball_count)
    container = @ballFrame.content_panel
    container.layout = nil
    container.detach_all_children

    @balls = []

    # Create a texture for our balls to use.
    tex = SubTex.new(TextureManager.load("images/ball.png",
                                         Texture::MinificationFilter::NearestNeighborNoMipMaps, TextureStoreFormat::GuessCompressedFormat, true))

    # Add balls
    
    ball_count.times do |i|
      ballComp = BallComponent.new("ball", tex, BALL_SIZE, BALL_SIZE, container.content_width, container.content_height)
      container.add(ballComp)
      @balls << ballComp
    end

    @ballFrame.title = " fps"
  end

  def updateExample(timer)
    now = Time.now # use the Ruby core libs when you want too
    dt = now - @start_time

    if dt.to_f > 2.0
      @ballFrame.title = "#{(@frames / dt).round} fps"
      @start_time = now
      @frames = 0
    end

    unless @skip_ball_collide
      length = @balls.length
      length.times do |i|
        (length - i - 1).times do |j|
          @balls[i].collides? @balls[i + j + 1]
        end
      end
    end

    @frames += 1
  end
end

BubbleMarkUIExample.start(BubbleMarkUIExample.new)
