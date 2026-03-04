public class Level extends Screen {
    private final float pauseX = 10, pauseY = 25, pauseW = 150, pauseH = 50;
    private final float timerWidth = 50;
    private final float dotSize = 25;
    private final float dotBuffer = 0.75;
    private final float dotFrames = FRAME_RATE * dotBuffer;
    private final float hashtagBuffer = 0.1;
    private final float hashtagFrames = FRAME_RATE * hashtagBuffer;

    private ScreenID id;
    // private String name; We will want to use this later for pause/death screen
    private ArrayList<Mascot> mascots;
    private ArrayList<Mover> movers;
    private ArrayList<Collidable> collidables;
    private ArrayList<Interactable> interactables;


    private float startTime;
    private boolean started = false;

    private float dotAnimation = 0;
    private float hashtagAnimation = 0;
    
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
    }

    public void drawSelf() {
        if(!started) {
            started = true;
            startTime = millis();
        }
        int terminals = 0;

        background(LIGHT_ABG);

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
            if(intCode == InteractCode.TERMINAL) {
                terminals++;
            }
        }

        for(Collidable collidable : collidables) {
            collidable.drawSelf();
        }
        for(Interactable interactable : interactables) {
            if(interactable.underMascot()) {
                interactable.drawSelf();
            }
        }
        for(Mover mover : movers) {
            mover.drawSelf();
        }
        for(Interactable interactable : interactables) {
            if(!interactable.underMascot()) {
                interactable.drawSelf();
            }
        }

        drawOverlay(terminals);
    }

    public void drawOverlay(int terminals) {
        boldButton("Pause (" + pauseKey + ")", pauseX, pauseY, pauseW, pauseH);
        timer();
        progress(terminals);
    }

    public void timer() {
        int seconds = (int) ((Math.floor(millis() - startTime) / MILLI));
        String secondsString = String.valueOf(seconds);
        setText(Size.MED, GRAY);
        centerText(secondsString, WIDTH - timerWidth * secondsString.length(), WIDTH, pauseY + pauseH);
    }

    public void progress(int terminals) {
        if(terminals == 1) {
            dotAnimation = (dotAnimation + 1) % (4 * dotFrames); 
            hashtagAnimation = 0;
            fill(GRAY);
            float h = HEIGHT - BLOCK_SIZE; 
            if(dotAnimation >= dotFrames) {
                ellipse(WIDTH / 2 - dotSize * 1.5, h, dotSize, dotSize);
            }
            if(dotAnimation >= 2 * dotFrames) {
                ellipse(WIDTH / 2, h, dotSize, dotSize);
            }
            if(dotAnimation >= 3 * dotFrames) {
                ellipse(WIDTH / 2 + dotSize * 1.5, h, dotSize, dotSize);
            } 
        }
        else if(terminals == 2) {
            dotAnimation = dotFrames;
            hashtagAnimation = (hashtagAnimation + 1) % (21 * hashtagFrames); 

            String progress = "";
            String fullProgress = "[";
            for(int i = 1; i <= 20; i++) {
                if(hashtagAnimation >= i * hashtagFrames) {
                    progress += "#";
                }
                else {
                    progress += "   ";
                }
                fullProgress += "#";
            }
            fullProgress += "]";

            setText(Size.MED, GRAY);
            float textWidth = textWidth(fullProgress);
            float startLoc = (WIDTH - textWidth) / 2;
            text("[", startLoc, HEIGHT - BLOCK_SIZE / 2);
            text(progress, startLoc + textWidth("["), HEIGHT - BLOCK_SIZE / 2);
            text("]", startLoc + textWidth(fullProgress) - textWidth("]"), HEIGHT - BLOCK_SIZE / 2);
        }
        else {
            dotAnimation = dotFrames;
            hashtagAnimation = 0;
        }
    }

    public ScreenID processClick() {
        // TODO: will have to process pause functionality
        return id;
    }
}