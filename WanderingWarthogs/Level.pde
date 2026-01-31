public class Level extends Screen {
    private ScreenID id;
    // private String name; We will want to use this later for pause/death screen
    private Mover[] movers;
    private Interactable[] obstacles;
    
    public Level(LevelInfo levelInfo) {
        this.id = levelInfo.id;
        // this.name = levelInfo.name;
        this.movers = levelInfo.movers;
        this.obstacles = levelInfo.obstacles;
    }

    public void drawSelf() {
        background(LIGHT_ABG);
        for(int h = 0; h <= HEIGHT; h += BLOCK_SIZE) {
            line(0, h, WIDTH, h);
        }
        for(int w = 0; w <= WIDTH; w += BLOCK_SIZE) {
            line(w, 0, w, HEIGHT);
        }
        
        for(Mover mover : movers) {
            mover.moveSelf();
        }
        for(Interactable obstacle : obstacles) {
            obstacle.interact(movers);
        }
        for(Interactable obstacle : obstacles) {
            obstacle.drawSelf();
        }
        for(Mover mover : movers) {
            mover.drawSelf();
        }
    }

    public ScreenID processClick() {
        // TODO: will have to process pause and back functionality
        return id;
    }
}