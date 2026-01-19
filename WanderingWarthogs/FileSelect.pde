public class FileSelect extends Screen {
    public final int NUM_SLOTS = 3;
    public final float SLOT_SIZE = 400;
    public final float SLOT_GAP = (WIDTH - NUM_SLOTS * SLOT_SIZE) / (NUM_SLOTS + 1);
    public Coordinate[] slotLocs = new Coordinate[NUM_SLOTS];

    public FileSelect() {
        for(int i = 0; i < NUM_SLOTS; i++) {
            float x = SLOT_GAP  + (SLOT_SIZE + SLOT_GAP) * i;
            float y = (HEIGHT - LARGE_FONT_SIZE - SLOT_SIZE) / 2 + LARGE_FONT_SIZE;
            slotLocs[i] = new Coordinate(x, y);
        }
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fillColor(ORANGE);
        centerText("Wandering Warthogs", LARGE_FONT_SIZE);

        for(int i = 0; i < NUM_SLOTS; i++) {
            fileSlot(i + 1, slotLocs[i].x, slotLocs[i].y);
        }
    }

    public void fileSlot(int fileNo, float x, float y) {
        fillColor(GRAY);

        // Draw thicker outline on highlighted file slots
        if(mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE)) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }
        
        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        fillColor(DARK_ABG);
        PFont ubuntuMedium = createFont(FONTS_DIR + "Ubuntu-Medium.ttf", MED_FONT_SIZE);
        textFont(ubuntuMedium);
        centerText("File " + fileNo, x, x + SLOT_SIZE, y + MED_FONT_SIZE);
    }

    public ScreenID processClick() {
        for(int i = 0; i < NUM_SLOTS; i++) {
            if(mouseInRect(slotLocs[i].x, slotLocs[i].y, SLOT_SIZE, SLOT_SIZE)) {
                // TODO: Implement reading from save file
                return ScreenID.LEVEL_SELECT;
            }
        }
        return ScreenID.FILE_SELECT;
    }
}