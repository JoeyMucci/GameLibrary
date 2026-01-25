public class TheTechStack extends Screen {
    private Raccoon resolute = new Raccoon(WIDTH/2 - BLOCK_SIZE, HEIGHT - 75 - BLOCK_SIZE * 2, true);
    private Quokka questing = new Quokka(WIDTH/2 + BLOCK_SIZE, HEIGHT - 75 - BLOCK_SIZE * 2 - contactThreshold, true);

    private Interactable[] obstacles = {
        new Block(0, 31, 16, 17),
        new Block(0, 31, 0, 1),
        new Block(0, 1, 0, 17),
        new Block(30, 31, 0, 17),
        new Block(25, 29, 15, 15),
        new Block(26, 28, 14, 14),
        new Block(27, 27, 13, 13),
        new Block(2, 13, 11, 11),
        new Block(18, 24, 11, 11),
        new Block(4, 6, 10, 10),
        new Block(4, 4, 8, 9),
        new Block(7, 13, 6, 6),
        new Block(18, 29, 6, 6),
        new Block(4, 4, 4, 4)
    };

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

        for(Interactable obstacle : obstacles) {
            obstacle.drawSelf();
            obstacle.interact(questing, resolute);
        }


        questing.drawSelf();
        resolute.drawSelf();
    }

    public ScreenID processClick() {
        return ScreenID.TTS;
    }
}