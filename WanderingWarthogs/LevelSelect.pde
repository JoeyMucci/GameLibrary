public class LevelSelect extends Screen {
    private final int TOP_LEVELS = (NUM_LEVELS + 1) / 2, BOTTOM_LEVELS = NUM_LEVELS / 2;
    private final float SLOT_SIZE = 320;
    private final float TOP_GAP = (WIDTH - TOP_LEVELS * SLOT_SIZE) / (TOP_LEVELS + 1);
    private final float BOTTOM_GAP = (WIDTH - BOTTOM_LEVELS * SLOT_SIZE) / (BOTTOM_LEVELS + 1);
    private final float VERTICAL_GAP = (HEIGHT - (2 * SLOT_SIZE)) / (2 + 1);
    private final float backX = 10, backY = 10, backW = 150, backH = 50;
    private Coordinate[] slotLocs = new Coordinate[NUM_LEVELS];
    private final LevelInfo[] LEVEL_INFO = {
        levels.get(ScreenID.TTS),
        levels.get(ScreenID.DC),
        levels.get(ScreenID.ALAP),
        levels.get(ScreenID.TFT),
        levels.get(ScreenID.TTC)
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
            levelSlot(LEVEL_INFO[i].name, LEVEL_INFO[i].data, slotLocs[i].x, slotLocs[i].y);
        }
        boldButton("Back", backX, backY, backW, backH);
    }

    private void levelSlot(String name, SaveData data, float x, float y) {
        // Draw thicker outline on highlighted level slots
        stroke(DARK_ABG);
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


        int numSprites = 3;
        float spriteWidth = sprites.get("questing-chip.png").width;
        float spriteHeight = sprites.get("questing-chip.png").height;
        float gapWidth = (SLOT_SIZE - (spriteWidth * numSprites)) / (numSprites + 1);

        if(data.questingGet) {
            tint(OCTAL_MAX, OCTAL_MAX);
        }
        else {
            tint(OCTAL_MAX, OCTAL_MAX / 2);
        }
        image(sprites.get("questing-chip.png").image, x + gapWidth, y + MED_FONT_SIZE);

        if(data.canonicalGet) {
            tint(OCTAL_MAX, OCTAL_MAX);
        }
        else {
            tint(OCTAL_MAX, OCTAL_MAX / 2);
        }
        image(sprites.get("canonical-chip.png").image, x + 2 * gapWidth + spriteWidth, y + MED_FONT_SIZE);

        if(data.resoluteGet) {
            tint(OCTAL_MAX, OCTAL_MAX);
        }
        else {
            tint(OCTAL_MAX, OCTAL_MAX / 2);
        }
        image(sprites.get("resolute-chip.png").image, x + 3 * gapWidth + 2 * spriteWidth, y + MED_FONT_SIZE);

        tint(OCTAL_MAX, OCTAL_MAX);
        image(sprites.get("clock.png").image, x + (gapWidth + 2 * gapWidth + spriteWidth) / 2, y + MED_FONT_SIZE + spriteHeight * 1.25);

        setText(Size.SMALL, DARK_ABG);
        String time = "???";
        if(data.clearTime != NOT_CLEARED) {
            String timePrefix = "";
            if(data.clearTime < 100) {
                timePrefix += "0";
            }
            if(data.clearTime < 10) {
                timePrefix += "0";
            }
            time = timePrefix + data.clearTime;
        }

        centerText(
            time,
            x + (gapWidth + 2 * gapWidth + spriteWidth) / 2 + spriteHeight,
            x + SLOT_SIZE,
            y + MED_FONT_SIZE + spriteHeight * 1.75
        );
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
