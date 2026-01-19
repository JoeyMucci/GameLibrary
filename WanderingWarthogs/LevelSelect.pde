public class LevelSelect extends Screen {
    public final int NUM_LEVELS = 5;
    public final int TOP_LEVELS = (NUM_LEVELS + 1) / 2, BOTTOM_LEVELS = NUM_LEVELS / 2;
    public final float SLOT_SIZE = 300;
    public final float TOP_GAP = (WIDTH - TOP_LEVELS * SLOT_SIZE) / (TOP_LEVELS + 1);
    public final float BOTTOM_GAP = (WIDTH - BOTTOM_LEVELS * SLOT_SIZE) / (BOTTOM_LEVELS + 1);
    public final float VERTICAL_GAP = (HEIGHT - (2 * SLOT_SIZE)) / (2 + 1);
    public Coordinate[] slotLocs = new Coordinate[NUM_LEVELS];
    public final LevelInfo[] LEVEL_INFO = {
        new LevelInfo(ScreenID.TTS, "The Tech Stack"),
        new LevelInfo(ScreenID.TTC, "To the Core"),
        new LevelInfo(ScreenID.LEVEL3, "LEVEL3"),
        new LevelInfo(ScreenID.LEVEL4, "LEVEL4"),
        new LevelInfo(ScreenID.LEVEL5, "LEVEL5")
    };

    public LevelSelect() {
        assert NUM_LEVELS == LEVEL_INFO.length;
        float topy = VERTICAL_GAP;
        float bottomy = VERTICAL_GAP * 2 + SLOT_SIZE;

        for(int i = 0; i < TOP_LEVELS; i++) {
            float x = TOP_GAP  + (SLOT_SIZE + TOP_GAP) * i;
            slotLocs[i] = new Coordinate(x, topy);
        }

        for(int i = 0; i < BOTTOM_LEVELS; i++) {
            float x = BOTTOM_GAP  + (SLOT_SIZE + BOTTOM_GAP) * i;
            slotLocs[i + TOP_LEVELS] = new Coordinate(x, bottomy);
        }
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        for(int i = 0; i < NUM_LEVELS; i++) {
            levelSlot(LEVEL_INFO[i].name, slotLocs[i].x, slotLocs[i].y);
        }
    }

    public void levelSlot(String name, float x, float y) {
        fillColor(GRAY);

        // Draw thicker outline on highlighted level slots
        if(mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE)) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }
        
        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        fillColor(DARK_ABG);
        PFont ubuntuLight = createFont(FONTS_DIR + "Ubuntu-Light.ttf", SMALL_FONT_SIZE);
        textFont(ubuntuLight);
        centerText(name, x, x + SLOT_SIZE, y + SMALL_FONT_SIZE);
    }

    public ScreenID processClick() {
        for(int i = 0; i < NUM_LEVELS; i++) {
            if(mouseInRect(slotLocs[i].x, slotLocs[i].y, SLOT_SIZE, SLOT_SIZE)) {
                return LEVEL_INFO[i].id;
            }
        }
        return ScreenID.LEVEL_SELECT;
    }
}