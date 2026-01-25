public class TheTechStack extends Screen {
    Raccoon resolute = new Raccoon(WIDTH/2, HEIGHT - 75, true);
    Quokka questing = new Quokka(WIDTH/2, HEIGHT - 75, true);

    public TheTechStack() {
        
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        // PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        // textFont(ubuntuBold);
        // fill(ORANGE);
        // centerText("The Tech Stack", 400);
        questing.moveSelf();
        resolute.moveSelf();
        for(int h = 0; h <= HEIGHT; h += BLOCK_SIZE) {
            line(0, h, WIDTH, h);
        }
        for(int w = 0; w <= WIDTH; w += BLOCK_SIZE) {
            line(w, 0, w, HEIGHT);
        }
        questing.drawSelf();
        resolute.drawSelf();
    }

    public ScreenID processClick() {
        return ScreenID.TTS;
    }
}