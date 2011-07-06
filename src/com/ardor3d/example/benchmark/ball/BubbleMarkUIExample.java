package com.ardor3d.example.benchmark.ball;

import com.ardor3d.example.ExampleBase;
import com.ardor3d.extension.ui.UICheckBox;
import com.ardor3d.extension.ui.UIComponent;
import com.ardor3d.extension.ui.UIContainer;
import com.ardor3d.extension.ui.UIFrame;
import com.ardor3d.extension.ui.UIHud;
import com.ardor3d.extension.ui.UILabel;
import com.ardor3d.extension.ui.UIRadioButton;
import com.ardor3d.extension.ui.backdrop.SolidBackdrop;
import com.ardor3d.extension.ui.event.ActionEvent;
import com.ardor3d.extension.ui.event.ActionListener;
import com.ardor3d.extension.ui.layout.AnchorLayout;
import com.ardor3d.extension.ui.layout.AnchorLayoutData;
import com.ardor3d.extension.ui.util.Alignment;
import com.ardor3d.extension.ui.util.ButtonGroup;
import com.ardor3d.extension.ui.util.SubTex;
import com.ardor3d.image.Texture;
import com.ardor3d.image.TextureStoreFormat;
import com.ardor3d.math.ColorRGBA;
import com.ardor3d.util.ReadOnlyTimer;
import com.ardor3d.util.TextureManager;


// The famous BubbleMark UI test, recreated using Ardor3D UI components.
public class BubbleMarkUIExample extends ExampleBase {
    public static final int BALL_SIZE = 52;
    private BallComponent[] balls;
    private int frames = 0;
    private long startTime = System.currentTimeMillis();
    private UIHud hud;
    private UIFrame ballFrame;
    private boolean skipBallCollide = false;

    public static void main(final String[] args) {
        start(BubbleMarkUIExample.class);
    }

    // Initialize our scene.
    @Override
    protected void initExample() {
        _canvas.setTitle("BubbleMarkUIExample");
        final int width = _canvas.getCanvasRenderer().getCamera().getWidth();
        final int height = _canvas.getCanvasRenderer().getCamera().getHeight();

        hud = new UIHud();

        // Add Frame for balls
        ballFrame = new UIFrame("Bubbles");
        ballFrame.updateMinimumSizeFromContents();
        ballFrame.pack(500, 300);
        ballFrame.layout();
        ballFrame.setResizeable(false);
        ballFrame.setHudXY(5, 5);
        ballFrame.setUseStandin(false);
        hud.add(ballFrame);

        // Add background
        ballFrame.getContentPanel().setBackdrop(new SolidBackdrop(ColorRGBA.WHITE));

        // Add Frame for config
        hud.add(buildConfigFrame(width, height));

        resetBalls(16);
        _root.attachChild(hud);

        hud.setupInput(_canvas, _physicalLayer, _logicalLayer);
    }

    private UIFrame buildConfigFrame(final int width, final int height) {
        UIFrame configFrame = new UIFrame("Config");
        configFrame.updateMinimumSizeFromContents();
        configFrame.pack(320, 240);
        configFrame.setUseStandin(true);
        configFrame.setHudXY(width - configFrame.getLocalComponentWidth() - 5, height
                - configFrame.getLocalComponentHeight() - 5);

        configFrame.getContentPanel().setLayout(new AnchorLayout());

        final UICheckBox vsync = new UICheckBox("Enable vsync");
        vsync.setLayoutData(new AnchorLayoutData(Alignment.TOP_LEFT, configFrame.getContentPanel(),
                Alignment.TOP_LEFT, 5, -5));
        vsync.setSelectable(true);
        vsync.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent event) {
                _canvas.setVSyncEnabled(vsync.isSelected());
            }
        });

        final UICheckBox collide = new UICheckBox("Enable ball collision");
        collide.setLayoutData(new AnchorLayoutData(Alignment.TOP_LEFT, vsync, Alignment.BOTTOM_LEFT, 0, -5));
        collide.setSelectable(true);
        collide.setSelected(!skipBallCollide);
        collide.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent event) {
                skipBallCollide = !collide.isSelected();
            }
        });

        UILabel ballsLabel = new UILabel("# of balls:");
        
        ButtonGroup ballsGroup = new ButtonGroup();
        UIRadioButton balls16 = buildBallsButton(ballsGroup, ballsLabel, 16);
        UIRadioButton balls32 = buildBallsButton(ballsGroup, balls16, 32);
        UIRadioButton balls64 = buildBallsButton(ballsGroup, balls32, 64);
        UIRadioButton balls128 = buildBallsButton(ballsGroup, balls64, 128);
        
        ballsLabel.setLayoutData(new AnchorLayoutData(Alignment.TOP_LEFT, collide, Alignment.BOTTOM_LEFT, 0, -15));
        
        configFrame.getContentPanel().add(vsync);
        configFrame.getContentPanel().add(collide);        
        configFrame.getContentPanel().add(ballsLabel);
        configFrame.getContentPanel().add(balls16);
        configFrame.getContentPanel().add(balls32);
        configFrame.getContentPanel().add(balls64);
        configFrame.getContentPanel().add(balls128);
        configFrame.layout();
        
        return configFrame;
    }
    
    private UIRadioButton buildBallsButton(ButtonGroup group, UIComponent previous, final int number) {
        UIRadioButton button = new UIRadioButton("" + number);
        
        button.setLayoutData(new AnchorLayoutData(Alignment.TOP_LEFT, previous, Alignment.BOTTOM_LEFT, 0, -5));
        button.setSelectable(true);
        button.setSelected(true);
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent event) {
                resetBalls(number);
            }
        });
        button.setGroup(group);
        
        return button;
    }

    @Override
    protected void updateLogicalLayer(final ReadOnlyTimer timer) {
        hud.getLogicalLayer().checkTriggers(timer.getTimePerFrame());
    }

    private void resetBalls(final int ballCount) {
        final UIContainer container = ballFrame.getContentPanel();
        container.setLayout(null);
        container.detachAllChildren();

        balls = new BallComponent[ballCount];

        // Create a texture for our balls to use.
        final SubTex tex = new SubTex(TextureManager.load("images/ball.png",
                Texture.MinificationFilter.NearestNeighborNoMipMaps, TextureStoreFormat.GuessCompressedFormat, true));

        // Add balls
        for (int i = 0; i < balls.length; i++) {
            BallComponent ballComp = new BallComponent("ball", tex, BALL_SIZE, BALL_SIZE, 
                    container.getContentWidth(), container.getContentHeight());
            container.add(ballComp);
            balls[i] = ballComp;
        }

        ballFrame.setTitle(" fps");
    }
    

    @Override
    protected void updateExample(ReadOnlyTimer timer) {
        long now = System.currentTimeMillis();
        long dt = now - startTime;
        
        if (dt > 2000) {
            final long fps = Math.round(1e3 * frames / dt);
            ballFrame.setTitle(fps + " fps");
            startTime = now;
            frames = 0;
        }

        if (!skipBallCollide) {
            // Check collisions
            for (int i = 0; i < balls.length; i++) {
                for (int j = i + 1; j < balls.length; j++) {
                    balls[i].getBall().doCollide(balls[j].getBall());
                }
            }
        }

        frames++;
    }
}
