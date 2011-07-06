
final UICheckBox vsync = new UICheckBox("Enable vsync");
vsync.setLayoutData(new AnchorLayoutData(Alignment.TOP_LEFT, configFrame.getContentPanel(), Alignment.TOP_LEFT, 5, -5));
vsync.setSelectable(true);
vsync.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(final ActionEvent event) {
        _canvas.setVSyncEnabled(vsync.isSelected());
    }
});

