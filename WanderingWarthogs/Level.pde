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
    public final int MAX_SECONDS = 999;
    private final int maxTerminals = 2;
    private final int dots = 3, hashes = 20;
    private ScreenID id;
    private String name;
    private ArrayList<Mascot> mascots;
    private ArrayList<Mover> movers;
    private ArrayList<Collidable> collidables;
    private ArrayList<Interactable> interactables;

    private boolean hasQuesting;
    private boolean hasResolute;
    private boolean hasCanonical;
    private int clearTime;

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
        hasQuesting = levelInfo.data.questingGet;
        hasResolute = levelInfo.data.resoluteGet;
        hasCanonical = levelInfo.data.canonicalGet;
        clearTime = levelInfo.data.clearTime;
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

            if(interactables.get(i) instanceof Chip) {
                Chip ch = (Chip) interactables.get(i);
                if(
                    hasQuesting && ch.getID() == ChipID.QUESTING ||
                    hasResolute && ch.getID() == ChipID.RESOLUTE ||
                    hasCanonical && ch.getID() == ChipID.CANONICAL
                ) {
                    ch.setAlreadyGot();
                }
            }
        }
    }

    public void drawSelf() {
        int terminals = 0;

        background(LIGHT_ABG);

        if(!paused) {
            moveGame();
            for(Interactable interactable : interactables) {
                InteractCode intCode = interactable.interact(mascots);
                if(intCode == InteractCode.GET) {
                    if(((Chip) interactable).getID() == ChipID.QUESTING) {
                        hasQuesting = true;
                    }
                    else if(((Chip) interactable).getID() == ChipID.RESOLUTE) {
                        hasResolute = true;
                    }
                    else if(((Chip) interactable).getID() == ChipID.CANONICAL) {
                        hasCanonical = true;
                    }
                }
                else if(intCode == InteractCode.TERMINAL) {
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
            if(paused) {
                tint(OCTAL_MAX, OCTAL_MAX / 2);
            }
            else {
                tint(OCTAL_MAX, OCTAL_MAX);
            }
            collidable.drawSelf();
        }

        for(Interactable interactable : interactables) {
            if(interactable.underMascot()) {
                if(paused) {
                    tint(OCTAL_MAX, OCTAL_MAX / 2);
                }
                else {
                    tint(OCTAL_MAX, OCTAL_MAX);
                }
                interactable.drawSelf();
            }
        }
        for(Mover mover : movers) {
            if(paused) {
                tint(OCTAL_MAX, OCTAL_MAX / 2);
            }
            else {
                tint(OCTAL_MAX, OCTAL_MAX);
            }
            mover.drawSelf();
        }
        for(Interactable interactable : interactables) {
            if(!interactable.underMascot()) {
                if(paused) {
                    tint(OCTAL_MAX, OCTAL_MAX / 2);
                }
                else {
                    tint(OCTAL_MAX, OCTAL_MAX);
                }
                interactable.drawSelf();
            }
        }
    }

    public void drawPause() {
        fill(DARK_ABG);
        stroke(GRAY);
        strokeWeight(DEFAULT_STROKE);
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

    public int getTime() {
        int seconds = (int) (Math.floor(time));
        seconds = Math.min(seconds, MAX_SECONDS);
        return seconds;
    }
 
    public void timer() {
        int seconds = getTime();
        String secondsPrefix = "";
        if(seconds < 100) {
            secondsPrefix += "0";
        }
        if(seconds < 10) {
            secondsPrefix += "0";
        }
        String secondsString = secondsPrefix + seconds;
        setText(Size.MED, GRAY);
        centerText(secondsString, WIDTH - timerWidth * secondsString.length(), WIDTH, pauseY + pauseH);
        image(sprites.get("clock.png").image, WIDTH - textWidth(secondsString) - sprites.get("clock.png").width * 1.25, 0);
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
                    writeProgress();
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

    public void writeProgress() {
        String newContent = "";
        int index = levelIndices.get(id);

        String path = FILES_DIR + fileNum + ".csv";
        File file = new File(path);
        try (Scanner rowScanner = new Scanner(file)) {
            for(int i = 0; i < NUM_LEVELS; i++) {
                String line = rowScanner.nextLine();
                if(i != index) {
                    newContent += line + "\n";
                    continue;
                }

                int time = getTime();
                if(clearTime != NOT_CLEARED && clearTime < getTime()) {
                    time = clearTime;
                }

                String newLine = 
                    hasQuesting + "," +
                    hasResolute + "," +
                    hasCanonical + "," +
                    time;
                
                newContent += newLine + "\n";
            }
        }
        catch (FileNotFoundException e) {
            System.out.println("Could not read save file: " + path);
            System.exit(3);
        }

        try(BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            bw.write(newContent);
        }
        catch (IOException e) {
            System.out.println("Could not write to save file: " + path);
            System.exit(4);
        } 
    }
}