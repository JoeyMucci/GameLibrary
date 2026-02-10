public class Level extends Screen {
    private ScreenID id;
    // private String name; We will want to use this later for pause/death screen
    private ArrayList<Mascot> mascots;
    private ArrayList<Mover> movers;
    private ArrayList<Collidable> collidables;
    private ArrayList<Interactable> interactables;
    
    public Level(LevelInfo levelInfo) {
        this.id = levelInfo.id;
        // this.name = levelInfo.name;
        this.mascots = levelInfo.mascots;
        this.movers = new ArrayList<Mover>();
        this.collidables = levelInfo.collidables;
        this.interactables = levelInfo.interactables;

        for(int i = 0; i < this.mascots.size(); i++) {
            this.movers.add((Mover) this.mascots.get(i));
        }

        for(int i = 0; i < this.interactables.size(); i++) {
            if(this.interactables.get(i) instanceof Mover) {
                this.movers.add((Mover) this.interactables.get(i));
            }
            else if(this.interactables.get(i) instanceof Collidable) {
                this.collidables.add((Collidable) this.interactables.get(i));
            }
        }
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
            for(Mover otherMover : movers) {
                if((mover instanceof Mascot) != (otherMover instanceof Mascot)) {
                    ArrayList<Collidable> otherCollidable = new ArrayList<Collidable>(Arrays.asList(otherMover));
                    mover.collideX(otherCollidable);
                }
            }
            mover.collideX(collidables);
            for(Mover otherMover : movers) {
                if((mover instanceof Mascot) != (otherMover instanceof Mascot) || otherMover.isGrounded()) {
                    ArrayList<Collidable> otherCollidable = new ArrayList<Collidable>(Arrays.asList(otherMover));
                    mover.collideY(otherCollidable);
                }
            }
            mover.collideY(collidables);
        }
        for(Interactable interactable : interactables) {
            interactable.interact(mascots);
        }
        for(Mover mover : movers) {
            mover.drawSelf();
        }
        for(Collidable collidable : collidables) {
            collidable.drawSelf();
        }
        for(Interactable interactable : interactables) {
            interactable.drawSelf();
        }
    }

    public ScreenID processClick() {
        // TODO: will have to process pause and back functionality
        return id;
    }
}