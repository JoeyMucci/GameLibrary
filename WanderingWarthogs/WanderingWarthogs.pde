// Imports
import java.util.Map;
import static java.util.Map.entry; 

// Constants
public final int WIDTH = 1600, HEIGHT = 900;
public final int LARGE_FONT_SIZE = 128, MED_FONT_SIZE = 64;
public final int DEFAULT_STROKE = 2, THICK_STROKE = 8;

public final color ORANGE = #E95420, LIGHT_ABG = #77216F, DARK_ABG = #2C001E, GRAY = #AEA79F;

public final String MAIN_DIR = "WanderingWarthogs/";
public final String FONTS_DIR = MAIN_DIR + "fonts/";

enum ScreenID {
    FILE_SELECT, LEVEL_SELECT, LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5
}

// Game
public ScreenID currentScreen = ScreenID.FILE_SELECT;
Map<ScreenID, Screen> screens = Map.ofEntries(
    entry(ScreenID.FILE_SELECT, new FileSelect()),
    entry(ScreenID.LEVEL_SELECT, new LevelSelect())
);

public void settings() {
    size(WIDTH, HEIGHT);
}

public void setup() {
    stroke(DARK_ABG);
    strokeWeight(DEFAULT_STROKE);
}

public void draw() {
    screens.get(currentScreen).drawSelf();
}

public void mouseClicked() {
    currentScreen = screens.get(currentScreen).processClick();
}

// Utilities
public class Coordinate {
    public float x, y;

    public Coordinate(float x, float y) {
        this.x = x;
        this.y = y;
    }
}

public void centerText(String text, int height) {
    centerText(text, 0, WIDTH, height);
}

public void centerText(String text, float left, float right, float height) {
    float textWidth = textWidth(text);
    float wholeWidth = right - left;
    text(text, left + (wholeWidth - textWidth) / 2, height);
}

public void fillColor(color c) {
    fill(extractRed(c), extractGreen(c), extractBlue(c));
}

public void backgroundColor(color c) {
    background(extractRed(c), extractGreen(c), extractBlue(c));   
}

public int extractRed(color c) {
    return c >> 16 & 0xFF;
} 

public int extractGreen(color c) {
    return c >> 8 & 0xFF;
} 

public int extractBlue(color c) {
    return c & 0xFF;
} 

public boolean mouseInRect(float x, float y, float width, float height) {
    return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
}