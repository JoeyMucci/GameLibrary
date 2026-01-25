public class FileSelect extends Screen {
    private final int NUM_SLOTS = 3;
    private final float SLOT_SIZE = 400;
    private final float SLOT_GAP = (WIDTH - NUM_SLOTS * SLOT_SIZE) / (NUM_SLOTS + 1);
    private Coordinate[] slotLocs = new Coordinate[NUM_SLOTS];

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
            "bug-0.png", 
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
        for(int i = 0; i < NUM_SLOTS; i++) {
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
        setText(Size.LARGE, ORANGE);
        centerText("Wandering Warthogs", LARGE_FONT_SIZE);
        setText(Size.SMALL, GRAY);
        centerText(subtitle, LARGE_FONT_SIZE + SMALL_FONT_SIZE * 2);

        for(int i = 0; i < NUM_SLOTS; i++) {
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
        if(mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE)) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }
        fill(GRAY);
        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        setText(Size.MED, DARK_ABG);
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