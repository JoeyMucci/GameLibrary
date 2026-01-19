public class Level4 extends Screen {

    public Level4() {
        
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fill(ORANGE);
        centerText("Level 4", 400);
    }

    public ScreenID processClick() {
        return ScreenID.LEVEL4;
    }
}