abstract class Screen {
    public abstract void drawSelf();

    /**
    Respond to a mouseclick and return the new ScreenID
     */
    public abstract ScreenID processClick();
}