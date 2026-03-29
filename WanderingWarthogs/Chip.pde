public class Chip implements Interactable {
    private final float CONTACT_BUFFER = 10, MOVE_THRESHOLD = .01;
    private final float SPEED = 15;
    private ChipID id;
    private Coordinate location;
    private String spriteName;

    private float xLoc, yLoc;

    private boolean acquired;

    // It is useful to have chips at half heights
    public Chip(float rightBlock, float bottomBlock, ChipID id) {
        if(id == ChipID.QUESTING) {
            spriteName = "questing-chip.png";
            xLoc = 13 * BLOCK_SIZE;
        }
        else if(id == ChipID.RESOLUTE) {
            spriteName = "resolute-chip.png";
            xLoc = 17 * BLOCK_SIZE;
        }
        else {
            spriteName = "canonical-chip.png";
            xLoc = 15 * BLOCK_SIZE;
        }
        yLoc = 0;
        acquired = false;
        float leftX = (rightBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).width;
        float topY = (bottomBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).height;
        location = new Coordinate(leftX, topY);
        this.id = id;
    }

    public void drawSelf() {
        // Animate chip to the outline
        if(acquired) {
            moveSelf();
        }
        outline();
        image(sprites.get(spriteName).image, location.x, location.y);
    }

    public void outline() {
        noFill();
        stroke(GRAY);
        rect(
            xLoc + CONTACT_BUFFER,
            yLoc + CONTACT_BUFFER,
            2 * BLOCK_SIZE - 2 * CONTACT_BUFFER,
            2 * BLOCK_SIZE - 2 * CONTACT_BUFFER
        );
    }

    public void moveSelf() {
        float xDist = Math.abs(xLoc - location.x);
        float yDist = Math.abs(yLoc - location.y);

        if(Math.abs(xDist + yDist) < MOVE_THRESHOLD) {
            return;
        }

        // xMov^2 + yMov^2 = SPEED^2
        // xMov/yMov = xDist/yDist
        float speed = Math.min(SPEED, (float) Math.sqrt((float) Math.pow(xDist, 2) + (float) Math.pow(yDist, 2)));
        float ratio = Math.abs(xDist/yDist);
        float yMov = (float) Math.sqrt((float) Math.pow(speed, 2) / (1 + (float) Math.pow(ratio, 2)));
        float xMov = ratio * yMov; 

        if(location.x > xLoc) {
            location.x -= xMov;
        }
        else {
            location.x += xMov;
        }
        if(location.y > yLoc) {
            location.y -= yMov;
        }
        else {
            location.y += yMov;
        }
    }

    public ChipID getID() {
        return id;
    }
    
    public float getLeftX() {
        return location.x + CONTACT_BUFFER;
    }

    public float getRightX() {
        return location.x + sprites.get(spriteName).width - CONTACT_BUFFER;
    }

    public float getTopY() {
        return location.y + CONTACT_BUFFER;

    }

    public float getBottomY() {
        return location.y + sprites.get(spriteName).height - CONTACT_BUFFER;
    }

    public boolean underMascot() { return true;};

    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(
                id == ChipID.CANONICAL ||  
                id == ChipID.QUESTING && mascot.id == MoverID.QUOKKA ||
                id == ChipID.RESOLUTE && mascot.id == MoverID.RACCOON 
            ) {
                if(mascot.isTouching(this)) {
                    acquired = true;
                    return InteractCode.GET;
                }
            }
        }
        return InteractCode.OK;
    }
}