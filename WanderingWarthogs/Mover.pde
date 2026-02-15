public abstract class Mover implements Collidable {
    protected MoverID id;
    protected String spriteName;

    protected float  xSpeed, ySpeed;
    protected Coordinate location = new Coordinate(0, 0);
    protected Direction dir;
    protected boolean doingAction, isAirborne;

    public Mover(MoverID id, int rightBlock, int bottomBlock, Direction dir) {
        this.id = id;
        this.dir = dir;
        doingAction = false;
        isAirborne = false;
        setSpriteName(id);
        setRightX((rightBlock + 1) * BLOCK_SIZE);
        setBottomY((bottomBlock + 1) * BLOCK_SIZE);
    }

    public abstract void moveSelf();

    public void drawSelf() {
        setSpriteName(id);
        image(sprites.get(spriteName).image, location.x, location.y);
    }

    public void ground() {
        isAirborne = false;
    }

    public boolean isFacingRight() {
        return dir == Direction.RIGHT;
    }

    public boolean isDoingAction() {
        return doingAction;
    }

    public boolean isGrounded() {
        return !isAirborne;
    }

    public Coordinate getMidPoint() {
        float midX = location.x + sprites.get(spriteName).width / 2;
        float midY = location.y + sprites.get(spriteName).height / 2;
        return new Coordinate(midX, midY);
    }

    public Coordinate getTopLeft() {
        return location;
    }

    public Coordinate getBottomRight() {
        float rightX = location.x + sprites.get(spriteName).width;
        float bottomY = location.y + sprites.get(spriteName).height;
        return new Coordinate(rightX, bottomY);
    }

    public Coordinate getPrevTopLeft() {
        return new Coordinate(location.x - xSpeed, location.y - ySpeed);
    }

    public Coordinate getPrevBottomRight() {
        Coordinate bottomRightLocation = getBottomRight();
        return new Coordinate(bottomRightLocation.x - xSpeed, bottomRightLocation.y - ySpeed);
    }

    public void setLeftX(float x) {
        location.x = x; 
        xSpeed = 0;
    }

    public void setRightX(float x) {
        location.x = x - sprites.get(spriteName).width;
        xSpeed = 0;
    }

    public void setTopY(float y) {
        location.y = y;
        ySpeed = 0;
    }

    public void setBottomY(float y) {
        location.y = y - sprites.get(spriteName).height;
        ySpeed = 0;
    }

    public void collideX(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(leftInto(this, collidable)) {
                setLeftX(collidable.getBottomRight().x);
            }
            if(rightInto(this, collidable)) {
                setRightX(collidable.getTopLeft().x);
            }
        }
    }

    public void collideY(ArrayList<Collidable> collidables) {
        for(Collidable collidable : collidables) {
            if(jumpingInto(this, collidable)) {
                setTopY(collidable.getBottomRight().y);
            }
            if(fallingInto(this, collidable)) {
                setBottomY(collidable.getTopLeft().y);
                ground();
            }
        }
    }

    public boolean isTouching(Mover other) {
        return (
            getTopLeft().x <= other.getBottomRight().x &&
            getTopLeft().y <= other.getBottomRight().y &&
            getBottomRight().x >= other.getTopLeft().x &&
            getBottomRight().y >= other.getTopLeft().y
        );
    }

    protected void setSpriteName(MoverID id) {
        String spriteName = moverNames.get(id);
        switch(dir) {
        case LEFT:
            spriteName += "-left";
            break;
        case RIGHT:
            spriteName += "-right";
            break;
        case UP:
            spriteName += "-up";
            break;
        case DOWN:
            spriteName += "-down";
            break;
        default:
        }

        if(doingAction) {
            spriteName += "-" + "action";
        }
        spriteName += ".png";
        this.spriteName = spriteName;
    }
}