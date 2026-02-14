public abstract class Mover implements Collidable {
    protected MoverID id;
    protected String spriteName;

    protected float  xSpeed, ySpeed;
    protected Coordinate location = new Coordinate(0, 0);
    protected boolean facingRight, doingAction, isAirborne;

    public Mover(MoverID id, int rightBlock, int bottomBlock, boolean facingRight) {
        this.id = id;
        this.facingRight = facingRight;
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
        return facingRight;
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

    private void setSpriteName(MoverID id) {
        String spriteName = moverNames.get(id);
        if(facingRight) {            
            spriteName += "-" + "right";
        }
        else {
            spriteName += "-" + "left";
        }

        if(doingAction) {
            spriteName += "-" + "action";
        }
        spriteName += ".png";
        this.spriteName = spriteName;
    }
}