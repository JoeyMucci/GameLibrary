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

            // Need to do all x collisions before any y collisions
            for(Interactable obstacle : obstacles) {
                collideX(mover, obstacle.getTopLeft(), obstacle.getBottomRight());
            }
            for(Interactable obstacle : obstacles) {
                collideY(mover, obstacle.getTopLeft(), obstacle.getBottomRight());
            }


            mover.drawSelf();
        }
        
        for(Interactable obstacle : obstacles) {
            obstacle.drawSelf();
        }

    }

    public ScreenID processClick() {
        // TODO: will have to process pause and back functionality
        return id;
    }

    private void collideX(Mover mover, Coordinate obstacleTopLeft, Coordinate obstacleBottomRight) {
        // If not too low and not too high
        if(
            mover.getTopLeft().y < obstacleBottomRight.y &&
            mover.getBottomRight().y > obstacleTopLeft.y
        ) {
            // Left into obstacle
            if(
                mover.getPrevTopLeft().x >= obstacleBottomRight.x &&
                mover.getTopLeft().x <= obstacleBottomRight.x
            ) {
                mover.setLeftX(obstacleBottomRight.x);
            }

            // Right into obstacle
            if(
                mover.getPrevBottomRight().x <= obstacleTopLeft.x &&
                mover.getBottomRight().x >= obstacleTopLeft.x
            ) {
                mover.setRightX(obstacleTopLeft.x);
            }
        }
    }

    private void collideY(Mover mover, Coordinate obstacleTopLeft, Coordinate obstacleBottomRight) {
        // If not too far left and not too far right
        if(
            mover.getTopLeft().x < obstacleBottomRight.x &&
            mover.getBottomRight().x > obstacleTopLeft.x
        ) {
            // Jumping into obstacle
            if(
                mover.getPrevTopLeft().y >= obstacleBottomRight.y &&
                mover.getTopLeft().y <= obstacleBottomRight.y
            ) {
                mover.setTopY(obstacleBottomRight.y);
            }

            // Falling onto obstacle
            if(
                mover.getPrevBottomRight().y <= obstacleTopLeft.y &&
                mover.getBottomRight().y >= obstacleTopLeft.y
            ) {
                mover.setBottomY(obstacleTopLeft.y);
                mover.ground();
            }
        }
    }
}