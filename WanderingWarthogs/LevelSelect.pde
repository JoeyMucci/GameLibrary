public class LevelSelect extends Screen {

    public void drawSelf() {
        background(LIGHT_ABG);
    }

    public ScreenID processClick() {
        return ScreenID.LEVEL_SELECT;
    }
}