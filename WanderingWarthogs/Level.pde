enum PauseReason {
    PAUSE, BUG, SPIKE, COMPLETE
}

public class Level extends Screen {
    private final float pauseX = 10, pauseY = 25, pauseW = 150, pauseH = 50;
    private final float bigPauseWidth = 1000, bigPauseHeight = 300;
    private final float pauseButtonWidth = 2 * bigPauseWidth / 7, pauseGap = bigPauseWidth / 7, pauseButtonHeight = bigPauseHeight * 2 / 5;
    private final float startWidth = (WIDTH - bigPauseWidth) / 2;
    private final float pauseMenuX = startWidth + pauseGap, pauseContinueX = startWidth + 2 * pauseGap + pauseButtonWidth;
    private final float pauseCompleteX = startWidth + (bigPauseWidth - pauseButtonWidth) / 2;
    private final float smallPauseY = bigPauseHeight + LARGE_FONT_SIZE;
    private final float timerWidth = 50;
    private final float dotSize = 25;
    private final float dotBuffer = 0.75;
    private final float dotFrames = FRAME_RATE * dotBuffer;
    private final float hashtagBuffer = 0.1;
    private final float hashtagFrames = FRAME_RATE * hashtagBuffer;
    private final int maxTerminals = 2;
    private final int dots = 3, hashes = 20;
    private ScreenID id;
    private String name;
    private ArrayList<Mascot> mascots;
    private ArrayList<Mover> movers;
    private ArrayList<Collidable> collidables;
    private ArrayList<Interactable> interactables;


    private float time = 0;

    private float dotAnimation = 0;
    private float hashtagAnimation = 0;

    private boolean paused;
    private PauseReason pauseReason = PauseReason.PAUSE;

    public Level(LevelInfo levelInfo) {
        id = levelInfo.id;
        name = levelInfo.name;
        mascots = levelInfo.mascots;
        movers = new ArrayList<Mover>();
        collidables = levelInfo.collidables;
        interactables = levelInfo.interactables;
        paused = false;

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
        int terminals = 0;

        background(LIGHT_ABG);

        if(paused) {
            tint(MAX_OPACITY, MAX_OPACITY / 2);
        }
        else {
            tint(MAX_OPACITY, MAX_OPACITY);
        }

        if(!paused) {
            moveGame();
            for(Interactable interactable : interactables) {
                InteractCode intCode = interactable.interact(mascots);
                if(intCode == InteractCode.TERMINAL) {
                    terminals++;
                }
                else if(intCode == InteractCode.HIT) {
                    if(interactable instanceof Bug) {
                        pauseReason = PauseReason.BUG;
                    }
                    else if(interactable instanceof SpikeBlock) {
                        pauseReason = PauseReason.SPIKE;
                    }
                    pause();
                }
            }
        }

        drawGame();

        if(paused) {
            drawPause();
        }

        drawOverlay(terminals);
    }

    public void moveGame() {
        time += 1.0 / FRAME_RATE;
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
                        mover.getTopLeft().y < otherMover.getTopLeft().y
                    )
                ) {
                    ArrayList<Collidable> otherCollidable = new ArrayList<Collidable>(Arrays.asList(otherMover));
                    mover.collideY(otherCollidable);
                }
            }
            mover.collideY(collidables);
        }
    }

    public void drawGame() {
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
    }

    public void drawPause() {
        fill(DARK_ABG);
        stroke(GRAY);
        rect(startWidth, (HEIGHT - bigPauseHeight) / 2, bigPauseWidth, bigPauseHeight);
        setText(Size.MED, ORANGE);
        centerText(name, 0, WIDTH, bigPauseHeight + MED_FONT_SIZE);
        setText(Size.SMALL, GRAY);

        String subtitle = "";
        switch(pauseReason) {
            case PAUSE:
                subtitle = "paused";
                break;
            case BUG:
                subtitle = "slain by bug: segmentation fault (core dumped)";
                break;
            case SPIKE:
                subtitle = "slain by spike: do more research next time";
                break;
            case COMPLETE:
                subtitle = "complete";
                break;
            default:
        }
        centerText(subtitle, 0, WIDTH, bigPauseHeight + MED_FONT_SIZE + SMALL_FONT_SIZE);

        if(pauseReason == PauseReason.COMPLETE) {
            boldButton("Back to Menu", pauseCompleteX, smallPauseY, pauseButtonWidth, pauseButtonHeight);
        }
        else {
            boldButton("Back to Menu", pauseMenuX, smallPauseY, pauseButtonWidth, pauseButtonHeight);
            if(pauseReason == PauseReason.PAUSE) {
                boldButton("Resume", pauseContinueX, smallPauseY, pauseButtonWidth, pauseButtonHeight);
            }
            else {
                boldButton("Retry", pauseContinueX, smallPauseY, pauseButtonWidth, pauseButtonHeight);
            }
        }
    }

    public void drawOverlay(int terminals) {
        if(!paused) {
            boldButton("Pause (" + pauseKey + ")", pauseX, pauseY, pauseW, pauseH);
            progress(terminals);
        }
        timer();
        
    }

    public void timer() {
        int seconds = (int) (Math.floor(time));
        String secondsString = String.valueOf(seconds);
        setText(Size.MED, GRAY);
        centerText(secondsString, WIDTH - timerWidth * secondsString.length(), WIDTH, pauseY + pauseH);
    }

    public void progress(int terminals) {
        if(terminals == 1) {
            dotAnimation = (dotAnimation + 1) % ((dots + 1) * dotFrames);
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
        else if(terminals == maxTerminals) {
            dotAnimation = dotFrames;
            hashtagAnimation = (hashtagAnimation + 1);

            String progress = "";
            String fullProgress = "[";
            for(int i = 1; i <= hashes; i++) {
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

            if(progress.charAt(progress.length() - 1) == '#') {
                pauseReason = PauseReason.COMPLETE;
                togglePause();
            }
        }
        else {
            dotAnimation = dotFrames;
            hashtagAnimation = 0;
        }
    }

    public void pause() {
        paused = true;
    }
    
    public void unpause() {
        paused = false;
    }

    public void togglePause() {
        if(paused && pauseReason == PauseReason.PAUSE) {
            unpause();
        }
        else {
            pause();
        }
    }

    public ScreenID processClick() {
        if(!paused && mouseInRect(pauseX, pauseY, pauseW, pauseH)) {
            pauseReason = PauseReason.PAUSE;
            pause();
        }
        if(paused) {
            if(pauseReason == PauseReason.COMPLETE) {
                if(mouseInRect(pauseCompleteX, smallPauseY, pauseButtonWidth, pauseButtonHeight)) {
                    resetScreens();
                    return ScreenID.LEVEL_SELECT;
                }
            }
            else {
                if(mouseInRect(pauseMenuX, smallPauseY, pauseButtonWidth, pauseButtonHeight)) {
                    resetScreens();
                    return ScreenID.LEVEL_SELECT;
                }
                else if(mouseInRect(pauseContinueX, smallPauseY, pauseButtonWidth, pauseButtonHeight)) {
                    if(pauseReason != PauseReason.PAUSE) {
                        resetScreens();
                    }
                    unpause();
                }
            }
        }

        return id;
    }
}