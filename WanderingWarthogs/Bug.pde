public class Bug extends Mover implements Interactable {
    private final float SPEED = 1.5;
    private final Map<Direction, Direction> nextDirs = Map.ofEntries(
        entry(Direction.LEFT, Direction.UP),
        entry(Direction.RIGHT, Direction.DOWN),
        entry(Direction.UP, Direction.RIGHT),
        entry(Direction.DOWN, Direction.LEFT)
    );
    private final Map<Direction, Direction> prevDirs = Map.ofEntries(
        entry(Direction.LEFT, Direction.DOWN),
        entry(Direction.RIGHT, Direction.UP),
        entry(Direction.UP, Direction.LEFT),
        entry(Direction.DOWN, Direction.RIGHT)
    );
    private Map<Direction, Boolean> contactMap = new HashMap<>();

    public Bug(int rightBlock, int bottomBlock, Direction dir) {
        super(MoverID.BUG, rightBlock, bottomBlock, dir);
        Direction[] dirs = {
            Direction.LEFT,
            Direction.RIGHT,
            Direction.UP,
            Direction.DOWN
        };
        for(Direction direction : dirs) {
            contactMap.put(direction, direction == nextDirs.get(dir));
        }
    }

    public void moveSelf() {
        // If not touching the next direction, can proceed in the next direction
        if(!contactMap.get(nextDirs.get(dir))) {
            dir = nextDirs.get(dir);
        }
        // Else if touching the current direction, need to change course
        else if(contactMap.get(dir)) {
            dir = prevDirs.get(dir);

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

        // Move
        location.x += xSpeed;
        location.y += ySpeed;

        // Blockify the movements
        if(dir == Direction.LEFT) {
            int block = (int) Math.floor(location.x / BLOCK_SIZE);
            float blockLoc = (block + 1) * BLOCK_SIZE;
            if(location.x < blockLoc && location.x > blockLoc - SPEED) {
                location.x = blockLoc;
            }
        }
        if(dir == Direction.RIGHT) {
            int block = (int) Math.floor(location.x / BLOCK_SIZE);
            float blockLoc = block * BLOCK_SIZE;
            if(location.x > blockLoc && location.x < blockLoc + SPEED) {
                location.x = blockLoc;
            }
        }
        if(dir == Direction.UP) {
            int block = (int) Math.floor(location.y / BLOCK_SIZE);
            float blockLoc = (block + 1) * BLOCK_SIZE;
            if(location.y < blockLoc && location.y > blockLoc - SPEED) {
                location.y = blockLoc;
            }
        }
        if(dir == Direction.DOWN) {
            int block = (int) Math.floor(location.y / BLOCK_SIZE);
            float blockLoc = block * BLOCK_SIZE;
            if(location.y > blockLoc && location.y < blockLoc + SPEED) {
                location.y = blockLoc;
            }
        }

        // Reset what walls are touched
        contactMap.put(Direction.LEFT, false);
        contactMap.put(Direction.RIGHT, false);
        contactMap.put(Direction.UP, false);
        contactMap.put(Direction.DOWN, false);
    }

    public void collideX(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(leftInto(this, collidable)) {
                contactMap.put(Direction.LEFT, true);
            }
            if(rightInto(this, collidable)) {
                contactMap.put(Direction.RIGHT, true);
            }
        }
    }

    public void collideY(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(jumpingInto(this, collidable)) {
                contactMap.put(Direction.UP, true);
            }
            if(fallingInto(this, collidable)) {
                contactMap.put(Direction.DOWN, true);
            }
        }
    }

    public boolean underMascot() { return true;};

    // If comes into contact with mascot, notify hit
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(isTouching(mascot, 5)) {
                return InteractCode.HIT;
            }
        }
        return InteractCode.OK;
    }

}