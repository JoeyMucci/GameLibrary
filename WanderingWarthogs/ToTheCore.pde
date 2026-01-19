public class ToTheCore extends Screen {

    public ToTheCore() {
        
    }

    public void drawSelf() {
        backgroundColor(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fillColor(ORANGE);
        centerText("To The Core", 400);
    }

    public ScreenID processClick() {
        return ScreenID.TTC;
    }
}