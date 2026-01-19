public class ToTheCore extends Screen {

    public ToTheCore() {
        
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fill(ORANGE);
        centerText("To The Core", 400);
    }

    public ScreenID processClick() {
        return ScreenID.TTC;
    }
}