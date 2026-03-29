public class FileSelect extends Screen {
    private final float SLOT_SIZE = 400;
    private final float X_SIZE = 50;
    private final float X_BUFFER = 10;
    private final float SLOT_GAP = (WIDTH - NUM_FILES * SLOT_SIZE) / (NUM_FILES + 1);
    private Coordinate[] slotLocs = new Coordinate[NUM_FILES];

    private final int NUM_SPRITES = 7;
    private final FrozenSprite[] SPRITE_INFO = {
        new FrozenSprite(
            "quokka-right.png",
            "Move the Questing Quokka with the WAD keys",
            Align.START, 
            Align.START
        ),
        new FrozenSprite(
            "human-right.png", 
            "Attract nearby humans as the Questing Quokka with the S key",
            Align.START, 
            Align.MID
        ),
        new FrozenSprite(
            "bug-right.png", 
            "Watch out for bugs crawling around the walls", 
            Align.START, 
            Align.END
        ),
        new FrozenSprite(
            "terminal.png", 
            "Reach the terminals to complete the level and save your progress", 
            Align.MID, 
            Align.END
        ),
        new FrozenSprite(
            "canonical-chip.png", 
            "Collect computer chips along the way to prove your mettle", 
            Align.END, 
            Align.END
        ),
        new FrozenSprite(
            "trash.png", 
            "Find useful items from trash cans as the Resolute Raccoon with the down arrow key",
            Align.END, 
            Align.MID
        ),
        new FrozenSprite(
            "raccoon-left.png", 
            "Move the Resolute Raccoon with the arrow keys", 
            Align.END, 
            Align.START
        )
    };
    private Coordinate[] spriteLocs = new Coordinate[NUM_SPRITES];

    private final String HELP_SUBTITLE = "Hover over a sprite for tips on how to play";
    private String subtitle = HELP_SUBTITLE;

    public FileSelect() {
        assignSlots();
        assignSprites();
    }

    private void assignSlots() {
        float y = (HEIGHT - LARGE_FONT_SIZE - SLOT_SIZE) / 2 + LARGE_FONT_SIZE;
        for(int i = 0; i < NUM_FILES; i++) {
            float x = SLOT_GAP  + (SLOT_SIZE + SLOT_GAP) * i;
            slotLocs[i] = new Coordinate(x, y);
        }
    }

    private void assignSprites() {
        assert NUM_SPRITES == SPRITE_INFO.length;
        for(int i = 0; i < NUM_SPRITES; i++) {
            float x, y;
            switch(SPRITE_INFO[i].xAlign) {
            case START:
                x = 0;
                break;
            case MID:
                x = WIDTH / 2 - sprites.get(SPRITE_INFO[i].spriteName).width / 2;
                break;
            case END:
                x = WIDTH - sprites.get(SPRITE_INFO[i].spriteName).width;
                break;
            default:
                x = -sprites.get(SPRITE_INFO[i].spriteName).width;
            }
            switch(SPRITE_INFO[i].yAlign) {
            case START:
                y = 0;
                break;
            case MID:
                y = HEIGHT / 2 - sprites.get(SPRITE_INFO[i].spriteName).height / 2;
                break;
            case END:
                y = HEIGHT - sprites.get(SPRITE_INFO[i].spriteName).height;
                break;
            default:
                y = -sprites.get(SPRITE_INFO[i].spriteName).height;
            }
            spriteLocs[i] = new Coordinate(x, y);
        }
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        tint(MAX_OPACITY, MAX_OPACITY);
        setText(Size.LARGE, ORANGE);
        centerText("Wandering Warthogs", LARGE_FONT_SIZE);
        setText(Size.SMALL, GRAY);
        centerText(subtitle, LARGE_FONT_SIZE + SMALL_FONT_SIZE * 2);

        for(int i = 0; i < NUM_FILES; i++) {
            fileSlot(i + 1, slotLocs[i].x, slotLocs[i].y);
        }

        boolean hovering = false;
        for(int i = 0; i < NUM_SPRITES; i++) {
            if(mouseInRect(
                spriteLocs[i].x, spriteLocs[i].y,
                sprites.get(SPRITE_INFO[i].spriteName).width,
                sprites.get(SPRITE_INFO[i].spriteName).height
            )) {
                hovering = true;
                subtitle = SPRITE_INFO[i].description;
            }

            if(!hovering) {
                subtitle = HELP_SUBTITLE;
            }
            
            image(sprites.get(SPRITE_INFO[i].spriteName).image, spriteLocs[i].x, spriteLocs[i].y);
        }
    }

    private void fileSlot(int fileNo, float x, float y) {
        // Draw thicker outline on highlighted file slots
        stroke(DARK_ABG);
        if(
            mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE) &&
            !mouseInRect(x + SLOT_SIZE - X_SIZE - X_BUFFER, y + X_BUFFER, X_SIZE, X_SIZE)
        ) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }
        fill(GRAY);
        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        setText(Size.MED, DARK_ABG);
        centerText("File " + fileNo, x, x + SLOT_SIZE, y + MED_FONT_SIZE);

        SaveData[] data = loadFile(fileNo);
        if(data == null) {
            setText(Size.LARGE, ORANGE);
            centerText("NEW", x, x + SLOT_SIZE, y + 2 * LARGE_FONT_SIZE);
        }
        else {
            int numQuesting = 0;
            int numResolute = 0;
            int numCanonical = 0;
            int numClear = 0;
            int clearTime = 0;
            for(SaveData datum : data) {
                if(datum.questingGet) {
                    numQuesting++;
                }
                if(datum.resoluteGet) {
                    numResolute++;
                }
                if(datum.canonicalGet) {
                    numCanonical++;
                }
                if(datum.clearTime != NOT_CLEARED) {
                    numClear++;
                    clearTime += datum.clearTime;
                }
            }

            int numSprites = 3;
            float spriteWidth = sprites.get("questing-chip.png").width;
            float spriteHeight = sprites.get("questing-chip.png").height;
            float gapWidth = (SLOT_SIZE - (spriteWidth * numSprites)) / (numSprites + 1);

            image(sprites.get("questing-chip.png").image, x + gapWidth, y + MED_FONT_SIZE);
            image(sprites.get("canonical-chip.png").image, x + 2 * gapWidth + spriteWidth, y + MED_FONT_SIZE);
            image(sprites.get("resolute-chip.png").image, x + 3 * gapWidth + 2 * spriteWidth, y + MED_FONT_SIZE);

            setText(Size.SMALL, DARK_ABG);
            centerText(
                numQuesting + "/" + NUM_LEVELS,
                x + gapWidth,
                x + gapWidth + spriteWidth,
                y + spriteHeight + MED_FONT_SIZE + SMALL_FONT_SIZE
            );
            centerText(
                numCanonical + "/" + NUM_LEVELS,
                x + 2 * gapWidth + spriteWidth,
                x + 2 * gapWidth + 2 * spriteWidth,
                y + spriteHeight + MED_FONT_SIZE + SMALL_FONT_SIZE
            );
            centerText(
                numResolute + "/" + NUM_LEVELS,
                x + 3 * gapWidth + 2 * spriteWidth,
                x + 3 * gapWidth + 3 * spriteWidth,
                y + spriteHeight + MED_FONT_SIZE + SMALL_FONT_SIZE
            );

            centerText(
                numClear + "/" + NUM_LEVELS,
                x + gapWidth,
                x + gapWidth + spriteWidth,
                y + (2 + 1.0/2) * spriteHeight + MED_FONT_SIZE + SMALL_FONT_SIZE / 2
            );
            image(sprites.get("clock.png").image, x + 2 * gapWidth + spriteWidth, y + 2 * spriteHeight + MED_FONT_SIZE);
            String totalTime = "???";
            if(numClear == NUM_LEVELS) {
                totalTime = "" + clearTime;
            }
            centerText(
                totalTime,
                x + 3 * gapWidth + 2 * spriteWidth,
                x + 3 * gapWidth + 3 * spriteWidth,
                y + (2 + 1.0/2) * spriteHeight + MED_FONT_SIZE + SMALL_FONT_SIZE / 2
            );


            stroke(DARK_ABG);
            if(mouseInRect(x + SLOT_SIZE - X_SIZE - X_BUFFER, y + X_BUFFER, X_SIZE, X_SIZE)) {
                stroke(LIGHT_ABG);
            }
            strokeWeight(THICK_STROKE);
            line(x + SLOT_SIZE - X_SIZE - X_BUFFER, y + X_BUFFER, x + SLOT_SIZE - X_BUFFER, y + X_SIZE + X_BUFFER);
            line(x + SLOT_SIZE - X_BUFFER, y + X_BUFFER, x + SLOT_SIZE - X_SIZE - X_BUFFER, y + X_SIZE + X_BUFFER);
        }
    }

    public ScreenID processClick() {
        for(int i = 0; i < NUM_FILES; i++) {
            if(mouseInRect(slotLocs[i].x, slotLocs[i].y, SLOT_SIZE, SLOT_SIZE)) {
                if(mouseInRect(slotLocs[i].x + SLOT_SIZE - X_SIZE - X_BUFFER, slotLocs[i].y + X_BUFFER, X_SIZE, X_SIZE)) {
                    deleteFile(i + 1);
                    reloadFileSelect();
                    return ScreenID.FILE_SELECT;
                }
                else {
                    setFile(i + 1);
                    resetScreens();
                    return ScreenID.LEVEL_SELECT;
                }
            }
        }
        return ScreenID.FILE_SELECT;
    }
}

private class FrozenSprite {
    public String spriteName;
    public String description;
    public Align xAlign, yAlign;

    public FrozenSprite(String spriteName, String description, Align xAlign, Align yAlign) {
        this.spriteName = spriteName;
        this.description = description;
        this.xAlign = xAlign;
        this.yAlign = yAlign;
    }
}