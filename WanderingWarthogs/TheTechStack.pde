public class TheTechStack extends Screen {

    public TheTechStack() {
        
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fill(ORANGE);
        centerText("The Tech Stack", 400);
    }

    public ScreenID processClick() {
        return ScreenID.TTS;
    }
}