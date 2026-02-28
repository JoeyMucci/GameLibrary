// Imports
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import static java.util.Map.entry; 

// Constants
public final int WIDTH = 1600, HEIGHT = 900;
public final int BLOCK_SIZE = 50;
public final int BLOCK_WIDTH = WIDTH / BLOCK_SIZE - 1, BLOCK_HEIGHT = HEIGHT / BLOCK_SIZE - 1;
public final int LARGE_FONT_SIZE = 128, MED_FONT_SIZE = 64, SMALL_FONT_SIZE = 32;
public final int DEFAULT_STROKE = 2, THICK_STROKE = 8;

public final color ORANGE = #E95420, LIGHT_ABG = #77216F, DARK_ABG = #2C001E, GRAY = #AEA79F;

public final String MAIN_DIR = "WanderingWarthogs/";
public final String FONTS_DIR = MAIN_DIR + "fonts/";
public final String SPRITES_DIR = MAIN_DIR + "sprites/";

public final float CONTACT_THRESHOLD = 0.01;
public final float GRAVITY = 1.0 / 3.0;

public final Coordinate OFFSCREEN = new Coordinate(-1000, -1000);

enum ScreenID {
    FILE_SELECT, LEVEL_SELECT, TTS, DC, ALAP, TFT, TTC
}

enum MoverID {
    QUOKKA, RACCOON, HUMAN, BUG;
}

enum ItemID {
    REDKEY, BLUEKEY, BOOTS, MAGNET;
}

enum CoinID {
    QUESTING, RESOLUTE, CANONICAL;
}

enum InteractCode {
    OK, HIT
}

enum Direction {
    LEFT, RIGHT, UP, DOWN
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
    entry(MoverID.HUMAN, "human"),
    entry(MoverID.BUG, "bug")
);
public Map<MoverID, MovementKeys> mascotKeys = Map.ofEntries(
    entry(MoverID.QUOKKA, new MovementKeys('a', 'd', 'w', 's')),
    entry(MoverID.RACCOON, new MovementKeys(LEFT, RIGHT, UP, DOWN))
);
public Map<ItemID, String> itemNames = Map.ofEntries(
    entry(ItemID.REDKEY, "key-red"),
    entry(ItemID.BLUEKEY, "key-blue"),
    entry(ItemID.BOOTS, "boots"),
    entry(ItemID.MAGNET, "magnet")
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
    entry("trash-used.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 2)),
    entry("bug-right.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-up.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-left.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("bug-down.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("terminal.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("door-red.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 2)),
    entry("door-blue.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE * 2)),
    entry("key-red-left.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("key-red-right.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("key-blue-left.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("key-blue-right.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("boots-right.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("boots-left.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("magnet-left.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("magnet-right.png", new SpriteInfo(null, BLOCK_SIZE * 1.5, BLOCK_SIZE * 1.5)),
    entry("block.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("spikeblock.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("steelblock.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE)),
    entry("techblock.png", new SpriteInfo(null, BLOCK_SIZE, BLOCK_SIZE))
);

// Game
public ScreenID currentScreen = ScreenID.TFT;
public Map<Integer, Boolean> keyMap = new HashMap<>();
public Map<ScreenID, LevelInfo> levels = Map.ofEntries(
    entry(
        ScreenID.TTS,
        new LevelInfo(
            ScreenID.TTS,
            "The Tech Stack",
            new ArrayList<Mascot>(Arrays.asList(
                new Mascot(MoverID.QUOKKA, 4, 15, Direction.RIGHT),
                new Mascot(MoverID.RACCOON, 27, 15, Direction.LEFT)
            )),
            new ArrayList<Collidable>(Arrays.asList(
                new Block(8, 11, 15, 15),
                new Block(9, 10, 14, 14),
                new Block(10, 10, 13, 13),
                new Block(21, 24, 15, 15),
                new Block(22, 23, 14, 14),
                new Block(22, 22, 13, 13),
                new Block(15, 16, 15, 15),
                new Block(15, 16, 13, 13),
                new Block(2, 7, 11, 11),
                new Block(7, 7, 8, 11),
                new Block(7, 10, 8, 8),
                new Block(6, 6, 10, 10),
                new Block(21, 30, 8, 8),
                new Block(2, 4, 6, 8),
                new Block(27, 28, 6, 7),
                new TechBlock(12, 19, 11, 11),
                new TechBlock(13, 18, 10, 10),
                new TechBlock(14, 17, 9, 9),
                new TechBlock(15, 16, 8, 8)
            )),
            new ArrayList<Interactable>(Arrays.asList(
                new Door(4, 10, true),
                new Bug(15, 7, Direction.RIGHT),
                new Human(20, 15, Direction.LEFT),
                new Trash(29, 7, ItemID.REDKEY),
                new Coin(3, 10, CoinID.QUESTING),
                new Coin(19, 14, CoinID.RESOLUTE),
                new Coin(16, 3, CoinID.CANONICAL)
            ))
        )
    ),
    entry(
        ScreenID.DC,
        new LevelInfo(
            ScreenID.DC,
            "Dropped Connection",
            new ArrayList<Mascot>(Arrays.asList(
                new Mascot(MoverID.QUOKKA, 5, 15, Direction.RIGHT),
                new Mascot(MoverID.RACCOON, 6, 15, Direction.RIGHT)
            )),
            new ArrayList<Collidable>(Arrays.asList(
                new Block(3, 3, 15, 15),
                new Block(25, 25, 15, 15),
                new Block(27, 29, 15, 15),
                new Block(27, 28, 14, 14),
                new Block(27, 27, 13, 13),
                new Block(7, 13, 11, 11),
                new Block(18, 24, 11, 11),
                new Block(6, 6, 10, 11),
                new Block(5, 5, 9, 10),
                new Block(4, 4, 8, 9),
                new Block(7, 13, 6, 6),
                new Block(18, 24, 6, 6),
                new Block(4, 4, 4, 4),
                new Block(25, 29, 2, 3)
            )),
            new ArrayList<Interactable>(Arrays.asList(
                new SpikeBlock(2, 3, 6, 6),
                new SpikeBlock(25, 29, 6, 6),
                new Bug(19, 10, Direction.RIGHT),
                new Bug(4, 3, Direction.RIGHT),
                new Human(10, 10, Direction.RIGHT),
                new Trash(26, 15, ItemID.BOOTS),
                new Coin(3, 8.5, CoinID.QUESTING),
                new Coin(29, 5, CoinID.RESOLUTE),
                new Coin(3.5, 3, CoinID.CANONICAL)
            ))
        )
    ),
    entry(
        ScreenID.ALAP,
        new LevelInfo(
            ScreenID.ALAP,
            "Attach Like a Pro",
            new ArrayList<Mascot>(Arrays.asList(
                new Mascot(MoverID.QUOKKA, 18, 15, Direction.RIGHT),
                new Mascot(MoverID.RACCOON, 13, 3, Direction.LEFT)
            )),
            new ArrayList<Collidable>(Arrays.asList(
                new Block(12, 12, 15, 15),
                new Block(13, 13, 13, 15),
                new Block(20, 20, 15, 15),
                new Block(5, 5, 14, 14),
                new Block(21, 21, 14, 15),
                new Block(9, 9, 13, 13),
                new Block(17, 17, 12, 12),
                new Block(21, 21, 11, 12),
                new Block(2, 11, 11, 11),
                new Block(7, 7, 8, 10),
                new Block(6, 6, 9, 10),
                new Block(14, 16, 9, 9),
                new Block(2, 2, 6, 6),
                new Block(3, 3, 7, 7),
                new Block(18, 18, 6, 6),
                new Block(28, 28, 6, 6),
                new Block(5, 5, 4, 4),
                new Block(9, 9, 2, 3),
                new Block(19, 19, 2, 3),
                new Block(25, 25, 2, 3)
            )),
            new ArrayList<Interactable>(Arrays.asList(
                new SpikeBlock(22, 29, 15, 15),
                new SpikeBlock(21, 21, 10, 10),
                new SpikeBlock(7, 7, 7, 7),
                new SteelBlock(17, 29, 7, 7),
                new SteelBlock(4, 14, 4, 4),
                new Bug(5, 13, Direction.RIGHT),
                new Bug(9, 12, Direction.RIGHT),
                new Bug(15, 8, Direction.RIGHT),
                new Human(29, 14, Direction.LEFT),
                new Human(26, 6, Direction.LEFT),
                new Trash(14, 15, ItemID.MAGNET),
                new Coin(29, 4, CoinID.QUESTING),
                new Coin(26, 11, CoinID.RESOLUTE),
                new Coin(3, 14, CoinID.CANONICAL)
            ))
        )
    ),
    entry(
        ScreenID.TFT,
        new LevelInfo(
            ScreenID.TFT,
            "Two-Factor Trial",
            new ArrayList<Mascot>(Arrays.asList(
                new Mascot(MoverID.QUOKKA, 11, 15, Direction.LEFT),
                new Mascot(MoverID.RACCOON, 5, 15, Direction.LEFT)
            )),
            new ArrayList<Collidable>(Arrays.asList(
                new Block(7, 8, 14, 15),
                new Block(9, 9, 13, 15),
                new Block(25, 29, 15, 15),
                new Block(26, 29, 14, 14),
                new Block(27, 29, 13, 13),
                new Block(28, 29, 12, 12),
                new Block(29, 29, 11, 11),
                new Block(2, 4, 13, 13),
                new Block(18, 18, 8, 13),
                new Block(2, 2, 12, 12),
                new Block(17, 17, 12, 12),
                new Block(9, 9, 9, 11),
                new Block(13, 14, 11, 11),
                new Block(5, 6, 10, 10),
                new Block(10, 11, 10, 10),
                new Block(22, 25, 10, 10),
                new Block(22, 24, 9, 9),
                new Block(22, 23, 8, 8),
                new Block(8, 8, 9, 9),
                new Block(9, 10, 7, 7),
                new Block(21, 22, 7, 7),
                new Block(26, 26, 6, 7),
                new Block(2, 6, 6, 6),
                new Block(11, 11, 5, 5),
                new Block(19, 19, 5, 5),
                new Block(13, 16, 4, 4),
                new Block(24, 26, 4, 4)
            )),
            new ArrayList<Interactable>(Arrays.asList(
                new Door(4, 15, true),
                new Door(19, 15, false),
                new SpikeBlock(11, 20, 7, 7),
                new SpikeBlock(27, 29, 7, 7),
                new Bug(13, 10, Direction.RIGHT),
                new Bug(15, 11, Direction.DOWN),
                new Bug(14, 3, Direction.RIGHT),
                new Bug(25, 3, Direction.RIGHT),
                new Human(5, 9, Direction.LEFT),
                new Trash(6, 15, ItemID.BLUEKEY),
                new Trash(15, 15, ItemID.REDKEY),
                new Coin(8, 13, CoinID.QUESTING),
                new Coin(21, 9.5, CoinID.RESOLUTE),
                new Coin(28.5, 3, CoinID.CANONICAL)
            ))
        )
    ),
    entry(
        ScreenID.TTC,
        new LevelInfo(
            ScreenID.TTC,
            "To the Core",
            new ArrayList<Mascot>(),
            new ArrayList<Collidable>(),
            new ArrayList<Interactable>()
        )
    )
);

public Map<ScreenID, Screen> screens = Map.ofEntries(
    entry(ScreenID.FILE_SELECT, new FileSelect()),
    entry(ScreenID.LEVEL_SELECT, new LevelSelect()),
    entry(ScreenID.TTS, new Level(levels.get(ScreenID.TTS))),
    entry(ScreenID.DC, new Level(levels.get(ScreenID.DC))),
    entry(ScreenID.ALAP, new Level(levels.get(ScreenID.ALAP))),
    entry(ScreenID.TFT, new Level(levels.get(ScreenID.TFT))),
    entry(ScreenID.TTC, new Level(levels.get(ScreenID.TTC)))
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
    public ArrayList<Mascot> mascots;
    public ArrayList<Collidable> collidables;
    public ArrayList<Interactable> interactables;

    public LevelInfo(
        ScreenID id, String name,
        ArrayList<Mascot> mascots,
        ArrayList<Collidable> collidables,
        ArrayList<Interactable> interactables
    ) {
        this.id = id;
        this.name = name;
        this.mascots = mascots;
        this.collidables = collidables;
        this.interactables = interactables;
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

public interface Collidable {
    public void drawSelf();
    public Coordinate getTopLeft();
    public Coordinate getBottomRight();
}

public interface Interactable {
    public void drawSelf();
    public InteractCode interact(ArrayList<Mascot> mascots);
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

public boolean rightInto(Mover mover, Collidable collidable) {
    return (
        mover.getTopLeft().y < collidable.getBottomRight().y &&
        mover.getBottomRight().y > collidable.getTopLeft().y &&
        mover.getPrevBottomRight().x <= collidable.getTopLeft().x &&
        mover.getBottomRight().x >= collidable.getTopLeft().x
    );
}

public boolean leftInto(Mover mover, Collidable collidable) {
    return (
        mover.getTopLeft().y < collidable.getBottomRight().y &&
        mover.getBottomRight().y > collidable.getTopLeft().y &&
        mover.getPrevTopLeft().x >= collidable.getBottomRight().x &&
        mover.getTopLeft().x <= collidable.getBottomRight().x
    );
}

public boolean jumpingInto(Mover mover, Collidable collidable) {
    return (
        mover.getTopLeft().x < collidable.getBottomRight().x &&
        mover.getBottomRight().x > collidable.getTopLeft().x &&
        mover.getPrevTopLeft().y >= collidable.getBottomRight().y &&
        mover.getTopLeft().y <= collidable.getBottomRight().y
    );
}

public boolean jumpingInto(Mover mover, Collidable collidable, float xbuffer) {
    return (
        mover.getTopLeft().x + xbuffer < collidable.getBottomRight().x &&
        mover.getBottomRight().x - xbuffer > collidable.getTopLeft().x &&
        mover.getPrevTopLeft().y >= collidable.getBottomRight().y &&
        mover.getTopLeft().y <= collidable.getBottomRight().y
    );
}

public boolean fallingInto(Mover mover, Collidable collidable) {
    return (
        mover.getTopLeft().x < collidable.getBottomRight().x &&
        mover.getBottomRight().x > collidable.getTopLeft().x &&
        mover.getPrevBottomRight().y <= collidable.getTopLeft().y &&
        mover.getBottomRight().y >= collidable.getTopLeft().y
    );
}
