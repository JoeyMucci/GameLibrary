public class Bug extends Mover implements Interactable {
    private final float SPEED = 1.5;
    private final Map<Direction, Direction> nextDirs = Map.ofEntries(
        entry(Direction.RIGHT, Direction.DOWN),
        entry(Direction.DOWN, Direction.LEFT),
        entry(Direction.LEFT, Direction.UP),
        entry(Direction.UP, Direction.RIGHT)
    );
    private final Map<Direction, Direction> prevDirs = Map.ofEntries(
        entry(Direction.RIGHT, Direction.UP),
        entry(Direction.DOWN, Direction.RIGHT),
        entry(Direction.LEFT, Direction.DOWN),
        entry(Direction.UP, Direction.LEFT)
    );
    private boolean inContact;

    public Bug(int rightBlock, int bottomBlock, Direction dir) {
        super(MoverID.BUG, rightBlock, bottomBlock, dir);
        inContact = true;
    }

    public void moveSelf() {
        if(!inContact) {
            if(dir == Direction.RIGHT || dir == Direction.LEFT) {
                int blockOver = (int) Math.floor(location.x / BLOCK_SIZE);
                float underEstimate = blockOver * BLOCK_SIZE;
                if(location.x - underEstimate < BLOCK_SIZE / 2) {
                    location.x = underEstimate;
                }
                else {
                    location.x = underEstimate + BLOCK_SIZE;
                }
            }
            else {
                int blockOver = (int) Math.floor(location.y / BLOCK_SIZE);
                float underEstimate = blockOver * BLOCK_SIZE;
                if(location.y - underEstimate < BLOCK_SIZE / 2) {
                    location.y = underEstimate;
                }
                else {
                    location.y = underEstimate + BLOCK_SIZE;
                }
            }
            dir = nextDirs.get(dir);
        }

        xSpeed = 0;
        ySpeed = 0;
        switch(dir) {
        case LEFT:
            xSpeed = -SPEED;
            break;
        case RIGHT:
            xSpeed = SPEED;
            break;
        case UP:
            ySpeed = -SPEED;
            break;
        case DOWN:
            ySpeed = SPEED;
            break;
        default:
        }
        location.x += xSpeed;
        location.y += ySpeed;
        inContact = false;
    }

    public void collideX(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(leftInto(this, collidable)) {
                // Prevents false positives for narrow paths
                if(dir != nextDirs.get(Direction.LEFT)) {
                    inContact = true;
                }
                if(dir == Direction.LEFT) {
                    dir = prevDirs.get(dir);
                    setLeftX(collidable.getBottomRight().x);
                }
            }
            if(rightInto(this, collidable)) {
                
                if(dir != nextDirs.get(Direction.RIGHT)) {
                    inContact = true;
                }
                if(dir == Direction.RIGHT) {
                    dir = prevDirs.get(dir);
                    setRightX(collidable.getTopLeft().x);
                }
            }
        }
    }

    public void collideY(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(jumpingInto(this, collidable)) {
                // Prevents false positives for narrow paths
                if(dir != nextDirs.get(Direction.UP)) {
                    inContact = true;
                }
                if(dir == Direction.UP) {
                    dir = prevDirs.get(dir);
                    setTopY(collidable.getBottomRight().y);
                }
            }
            if(fallingInto(this, collidable)) {
                // Prevents false positives for narrow paths
                if(dir != nextDirs.get(Direction.DOWN)) {
                    inContact = true;
                }
                if(dir == Direction.DOWN) {
                    dir = prevDirs.get(dir);
                    setBottomY(collidable.getTopLeft().y);
                }
            }
        }
    }

    // If comes into contact with mascot, notify hit
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(isTouching(mascot)) {
                return InteractCode.HIT;
            }
        }
        return InteractCode.OK;
    }

}