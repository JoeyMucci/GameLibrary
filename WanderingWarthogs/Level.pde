public class Level extends Screen {
    private final float pauseX = 10, pauseY = 25, pauseW = 150, pauseH = 50;

    private ScreenID id;
    // private String name; We will want to use this later for pause/death screen
    private ArrayList<Mascot> mascots;
    private ArrayList<Mover> movers;
    private ArrayList<Collidable> collidables;
    private ArrayList<Interactable> interactables;

    private color bg;
    
    public Level(LevelInfo levelInfo) {
    id = levelInfo.id;
        // name = levelInfo.name;
        mascots = levelInfo.mascots;
        movers = new ArrayList<Mover>();
        collidables = levelInfo.collidables;
        interactables = levelInfo.interactables;

        // Add boundaries
        collidables.add(new BoundaryBlock(0, BLOCK_WIDTH, BLOCK_HEIGHT - 1, BLOCK_HEIGHT));
        collidables.add(new BoundaryBlock(0, BLOCK_WIDTH, 0, 1));
        collidables.add(new BoundaryBlock(0, 1, 0, BLOCK_HEIGHT));
        collidables.add(new BoundaryBlock(BLOCK_WIDTH - 1, BLOCK_WIDTH, 0, BLOCK_HEIGHT));

        for(int i = 0; i < mascots.size(); i++) {
            movers.add((Mover) mascots.get(i));
        }

        for(int i = 0; i < interactables.size(); i++) {
            if(interactables.get(i) instanceof Mover) {
                movers.add((Mover) interactables.get(i));
            }
            else if(interactables.get(i) instanceof Collidable) {
                collidables.add((Collidable) interactables.get(i));
            }
        }

        bg = LIGHT_ABG;
    }

    public void drawSelf() {
        background(bg);
        bg = LIGHT_ABG;

        for(Mover mover : movers) {
            mover.moveSelf();
            for(Mover otherMover : movers) {
                if(
                    (mover instanceof Mascot && otherMover instanceof Human) ||
                    (mover instanceof Human && otherMover instanceof Mascot)
                ) {
                    ArrayList<Collidable> otherCollidable = new ArrayList<Collidable>(Arrays.asList(otherMover));
                    mover.collideX(otherCollidable);
                }
            }
            mover.collideX(collidables);
            for(Mover otherMover : movers) {
                if(
                    (mover instanceof Mascot && otherMover instanceof Human) ||
                    (mover instanceof Human && otherMover instanceof Mascot) ||
                    // Mascot can land on a grounded mascot
                    (
                        mover instanceof Mascot && otherMover instanceof Mascot && otherMover.isGrounded() && 
                        mover.getTopLeft().y < otherMover.getTopLeft().y) 
                ) { 
                    ArrayList<Collidable> otherCollidable = new ArrayList<Collidable>(Arrays.asList(otherMover));
                    mover.collideY(otherCollidable);
                }
            }
            mover.collideY(collidables);
        }
        for(Interactable interactable : interactables) {
            InteractCode intCode = interactable.interact(mascots);
            if(intCode == InteractCode.HIT) {
                bg = ORANGE;
            }
        }
        for(Interactable interactable : interactables) {
            interactable.drawSelf();
        }
        for(Mover mover : movers) {
            mover.drawSelf();
        }
        for(Collidable collidable : collidables) {
            collidable.drawSelf();
        }

        drawOverlay();
    }

    public void drawOverlay() {
        boldButton("Pause (p)", pauseX, pauseY, pauseW, pauseH);
    }

    public ScreenID processClick() {
        // TODO: will have to process pause functionality
        return id;
    }
}