// Imports
import java.util.Map;
import static java.util.Map.entry; 

// Constants
public final int WIDTH = 1600, HEIGHT = 900;
public final int BLOCK_SIZE = 50;
public final int LARGE_FONT_SIZE = 128, MED_FONT_SIZE = 64, SMALL_FONT_SIZE = 32;
public final int DEFAULT_STROKE = 2, THICK_STROKE = 8;

public final color ORANGE = #E95420, LIGHT_ABG = #77216F, DARK_ABG = #2C001E, GRAY = #AEA79F;

public final String MAIN_DIR = "WanderingWarthogs/";
public final String FONTS_DIR = MAIN_DIR + "fonts/";
public final String SPRITES_DIR = MAIN_DIR + "sprites/";

public final float CONTACT_THRESHOLD = 0.01;

enum ScreenID {
    FILE_SELECT, LEVEL_SELECT, TTS, TTC, LEVEL3, LEVEL4, LEVEL5
}

enum MoverID {
    QUOKKA, RACCOON, HUMAN;
}

enum Size {
    LARGE, MED, SMALL
}

enum Align {
    START, MID, END
}

public final Map<MoverID, String> moverNames = Map.ofEntries(
    entry(MoverID.QUOKKA, "quokka"),
    entry(MoverID.RACCOON, "raccoon"),
    entry(MoverID.HUMAN, "human")
);
public Map<MoverID, MovementKeys> mascotKeys = Map.ofEntries(
    entry(MoverID.QUOKKA, new MovementKeys('a', 'd', 'w', 's')),
    entry(MoverID.RACCOON, new MovementKeys(LEFT, RIGHT, UP, DOWN))
);
public final Map<String, SpriteInfo> sprites = Map.ofEntries(
    entry("quokka-left.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("quokka-left-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("quokka-right.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("quokka-right-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("raccoon-left.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("raccoon-left-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("raccoon-right.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("raccoon-right-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 1.5)),
    entry("questing-chip.png", new SpriteInfo(null, BLOCK_SIZE * 2, BLOCK_SIZE * 2)),
    entry("resolute-chip.png", new SpriteInfo(null, BLOCK_SIZE * 2, BLOCK_SIZE * 2)),
    entry("canonical-chip.png", new SpriteInfo(null, BLOCK_SIZE * 2, BLOCK_SIZE * 2)),
    entry("human-left.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 3)),
    entry("human-left-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 3)),
    entry("human-right.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 3)),
    entry("human-right-action.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 3)),
    entry("trash.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 2)),
    entry("bug-0.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-90.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-180.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-270.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("terminal.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE))
);

// Game
public ScreenID currentScreen = ScreenID.TTS;
public Map<Integer, Boolean> keyMap = new HashMap<>();
public Map<ScreenID, LevelInfo> levels = Map.ofEntries(
    entry(
        ScreenID.TTS,
        new LevelInfo(
            ScreenID.TTS,
            "The Tech Stack",
            new Mover[] {
                new Mascot(MoverID.QUOKKA, 10, 15, true),
                new Mascot(MoverID.RACCOON, 20, 15, false)
            },
            new Interactable[] {
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
            }
        )
    ),
    entry(
        ScreenID.TTC,
        new LevelInfo(
            ScreenID.TTC,
            "To the Core",
            new Mover[] {
            },
            new Interactable[] {
            }
        )
    ),
    entry(
        ScreenID.LEVEL3,
        new LevelInfo(
            ScreenID.LEVEL3,
            "Level 3",
            new Mover[] {
            },
            new Interactable[] {
            }
        )
    ),
    entry(
        ScreenID.LEVEL4,
        new LevelInfo(
            ScreenID.LEVEL4,
            "Level 4",
            new Mover[] {
            },
            new Interactable[] {
            }
        )
    ),
    entry(
        ScreenID.LEVEL5,
        new LevelInfo(
            ScreenID.LEVEL5,
            "Level 5",
            new Mover[] {
            },
            new Interactable[] {
            }
        )
    )
);

public Map<ScreenID, Screen> screens = Map.ofEntries(
    entry(ScreenID.FILE_SELECT, new FileSelect()),
    entry(ScreenID.LEVEL_SELECT, new LevelSelect()),
    entry(ScreenID.TTS, new Level(levels.get(ScreenID.TTS))),
    entry(ScreenID.TTC, new Level(levels.get(ScreenID.TTC))),
    entry(ScreenID.LEVEL3, new Level(levels.get(ScreenID.LEVEL3))),
    entry(ScreenID.LEVEL4, new Level(levels.get(ScreenID.LEVEL4))),
    entry(ScreenID.LEVEL5, new Level(levels.get(ScreenID.LEVEL5)))
);

public void settings() {
    size(WIDTH, HEIGHT);
}

public void setup() {
    stroke(DARK_ABG);
    strokeWeight(DEFAULT_STROKE);
    loadSprites();
    mouseX = WIDTH / 2;
}

public void draw() {
    screens.get(currentScreen).drawSelf();
}

public void mouseClicked() {
    currentScreen = screens.get(currentScreen).processClick();
}

public void keyPressed() {
    if(key == CODED) {
        keyMap.put(keyCode, true);
    }

    // No caps letters allowed
    if(key >= 'A' && key <= 'Z') {
        key += 'a' - 'A';
    }

    keyMap.put((int) key, true);
}

public void keyReleased() {
    if(key == CODED) {
        keyMap.remove(keyCode);
    }

    // No caps letters allowed
    if(key >= 'A' && key <= 'Z') {
        key += 'a' - 'A';
    }

    keyMap.remove((int) key);
}

public boolean isKeyPressed(int ch) {
    return keyMap.get(ch) != null;
}

public void loadSprites() {
    for(String key : sprites.keySet()) {
        SpriteInfo val = sprites.get(key);
        val.image = loadImage(SPRITES_DIR + key);
    }
}

// Utilities
public class Coordinate {
    public float x, y;

    public Coordinate(float x, float y) {
        this.x = x;
        this.y = y;
    }
}

public class SpriteInfo {
    public PImage image;
    public float width, height;

    public SpriteInfo(PImage image, float width, float height) {
        this.image = image;
        this.width = width;
        this.height = height;
    }
}

public class LevelInfo {
    public ScreenID id;
    public String name;
    public Mover[] movers;
    public Interactable[] obstacles;

    public LevelInfo(ScreenID id, String name, Mover[] movers, Interactable[] obstacles) {
        this.id = id;
        this.name = name;
        this.movers = movers;
        this.obstacles = obstacles;
    }
}

public class MovementKeys {
    public int left, right, jump, action;

    public MovementKeys(int left, int right, int jump, int action) {
        this.left = left;
        this.right = right;
        this.jump = jump;
        this.action = action;
    }
}

public interface Interactable {
    public void drawSelf();
    public void interact(Mover[] movers);
}

public void backButton(float x, float y, float width, float height) {
    // Draw thicker outline if highlighted
    if(mouseInRect(x, y, width, height)) {
        strokeWeight(THICK_STROKE);
    }
    else {
        strokeWeight(DEFAULT_STROKE);
    }
    fill(GRAY);
    rect(x, y, width, height);
    setText(Size.SMALL, DARK_ABG);
    centerText("Back", x, x + width, y + SMALL_FONT_SIZE);
}

public void centerText(String text, float height) {
    centerText(text, 0, WIDTH, height);
}

public void centerText(String text, float left, float right, float height) {
    float textWidth = textWidth(text);
    float wholeWidth = right - left;
    text(text, left + (wholeWidth - textWidth) / 2, height);
}

public void setText(Size sz, color c) {
    fill(c);
    switch(sz) {
    case LARGE:
        PFont ubuntuBold = createFont(FONTS_DIR + "Ubuntu-Bold.ttf", LARGE_FONT_SIZE);
        textFont(ubuntuBold);
        break;
    case MED:
        PFont ubuntuMedium = createFont(FONTS_DIR + "Ubuntu-Medium.ttf", MED_FONT_SIZE);
        textFont(ubuntuMedium);
        break;
    case SMALL:
        PFont ubuntuLight = createFont(FONTS_DIR + "Ubuntu-Light.ttf", SMALL_FONT_SIZE);
        textFont(ubuntuLight);
        break;
    default:
    }
}

public boolean mouseInRect(float x, float y, float width, float height) {
    return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
}