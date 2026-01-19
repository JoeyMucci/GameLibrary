public class Level3 extends Screen {

    public Level3() {
        
    }

    public void drawSelf() {
        backgroundColor(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fillColor(ORANGE);
        centerText("Level 3", 400);
    }

    public ScreenID processClick() {
        return ScreenID.LEVEL3;
    }
}