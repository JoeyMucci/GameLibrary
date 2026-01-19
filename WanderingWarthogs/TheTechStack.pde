public class TheTechStack extends Screen {

    public TheTechStack() {
        
    }

    public void drawSelf() {
        backgroundColor(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fillColor(ORANGE);
        centerText("The Tech Stack", 400);
    }

    public ScreenID processClick() {
        return ScreenID.TTS;
    }
}