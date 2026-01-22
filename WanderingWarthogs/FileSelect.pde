public class FileSelect extends Screen {
    public final int NUM_SLOTS = 3;
    public final float SLOT_SIZE = 400;
    public final float SLOT_GAP = (WIDTH - NUM_SLOTS * SLOT_SIZE) / (NUM_SLOTS + 1);
    public Coordinate[] slotLocs = new Coordinate[NUM_SLOTS];

    public final int NUM_SPRITES = 7;
    public final FrozenSprite[] SPRITE_INFO = {
        new FrozenSprite(
            "quokka-right.png",
            "Move the Questing Quokka with the WAD keys",
            Align.START, 
            Align.START
        ),
        new FrozenSprite(
            "quokka-right-action.png", 
            "Smile as the Questing Quokka with the S key, attracting nearby humans", 
            Align.START, 
            Align.MID
        ),
        new FrozenSprite(
            "quokka-left.png", 
            "Watch out for bugs crawling around the walls", 
            Align.START, 
            Align.END
        ),
        new FrozenSprite(
            "quokka-left.png", 
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
            "raccoon-left-action.png", 
            "Search as the Resolute Raccoon with the down arrow key, finding useful items from trash cans", 
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
    public Coordinate[] spriteLocs = new Coordinate[NUM_SPRITES];

    public final String HELP_SUBTITLE = "Hover over a sprite for tips on how to play";
    public String subtitle = HELP_SUBTITLE;

    public FileSelect() {
        assignSlots();
        assignSprites();
    }

    public void assignSlots() {
        float y = (HEIGHT - LARGE_FONT_SIZE - SLOT_SIZE) / 2 + LARGE_FONT_SIZE;
        for(int i = 0; i < NUM_SLOTS; i++) {
            float x = SLOT_GAP  + (SLOT_SIZE + SLOT_GAP) * i;
            slotLocs[i] = new Coordinate(x, y);
        }
    }

    public void assignSprites() {
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
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        fill(ORANGE);
        centerText("Wandering Warthogs", LARGE_FONT_SIZE);
        PFont ubuntuLight = createFont(FONTS_DIR + "Ubuntu-Light.ttf", SMALL_FONT_SIZE);
        textFont(ubuntuLight);
        fill(GRAY);
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

    public void fileSlot(int fileNo, float x, float y) {
        fill(GRAY);

        // Draw thicker outline on highlighted file slots
        if(mouseInRect(x, y, SLOT_SIZE, SLOT_SIZE)) {
            strokeWeight(THICK_STROKE);
        }
        else {
            strokeWeight(DEFAULT_STROKE);
        }

        rect(x, y, SLOT_SIZE, SLOT_SIZE);
        fill(DARK_ABG);
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

public class FrozenSprite {
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

enum Align {
    START, MID, END
}