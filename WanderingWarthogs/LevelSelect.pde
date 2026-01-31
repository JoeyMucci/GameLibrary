public class LevelSelect extends Screen {
    private final int NUM_LEVELS = 5;
    private final int TOP_LEVELS = (NUM_LEVELS + 1) / 2, BOTTOM_LEVELS = NUM_LEVELS / 2;
    private final float SLOT_SIZE = 300;
    private final float TOP_GAP = (WIDTH - TOP_LEVELS * SLOT_SIZE) / (TOP_LEVELS + 1);
    private final float BOTTOM_GAP = (WIDTH - BOTTOM_LEVELS * SLOT_SIZE) / (BOTTOM_LEVELS + 1);
    private final float VERTICAL_GAP = (HEIGHT - (2 * SLOT_SIZE)) / (2 + 1);
    private final float backX = 10, backY = 10, backW = 150, backH = 50;
    private Coordinate[] slotLocs = new Coordinate[NUM_LEVELS];
    private final LevelInfo[] LEVEL_INFO = {
        levels.get(ScreenID.TTS),
        levels.get(ScreenID.TTC),
        levels.get(ScreenID.LEVEL3),
        levels.get(ScreenID.LEVEL4),
        levels.get(ScreenID.LEVEL5)
    };

    public LevelSelect() {
        assignLevels();
    }

    private void assignLevels() {
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
        backButton(backX, backY, backW, backH);
    }

    private void levelSlot(String name, float x, float y) {
        // Draw thicker outline on highlighted level slots
        if(mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE)) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }
        fill(GRAY);
        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        setText(Size.SMALL, DARK_ABG);
        centerText(name, x, x + SLOT_SIZE, y + SMALL_FONT_SIZE);
    }

    public ScreenID processClick() {
        for(int i = 0; i < NUM_LEVELS; i++) {
            if(mouseInRect(slotLocs[i].x, slotLocs[i].y, SLOT_SIZE, SLOT_SIZE)) {
                return LEVEL_INFO[i].id;
            }
        }
        if(mouseInRect(backX, backY, backW, backH)) {
            return ScreenID.FILE_SELECT;
        }
        return ScreenID.LEVEL_SELECT;
    }
}
