public abstract class Mascot {
    private final float XSPEED = 5, JUMPSPEED = 9, GRAVITY = 1.0 / 3.0;
    public float  xSpeed, ySpeed;

    public Coordinate location;
    public boolean facingRight, doingAction, isAirborne;

    protected int leftKey, rightKey, jumpKey, actionKey;
    protected String species;
    public String spriteName;

    protected Mascot(float x, float y, boolean facingRight) {
        this.location = new Coordinate(x, y);
        this.facingRight = facingRight;
        doingAction = false;
        isAirborne = false;
    }

    public void drawSelf() {
        image(sprites.get(spriteName).image, location.x, location.y);
    }

    public void moveSelf() {
        // Going left
        if(isKeyPressed(leftKey) && !isKeyPressed(rightKey)) {
            xSpeed = -XSPEED;   
            facingRight = false;
        }
        // Going right
        else if(isKeyPressed(rightKey) && !isKeyPressed(leftKey)) {
            xSpeed = XSPEED;
            facingRight = true;
        }
        else {
            xSpeed = 0;
        }

        // Initiate jump
        if(!isAirborne && isKeyPressed(jumpKey)) {
            isAirborne = true;
            ySpeed -= JUMPSPEED;
        }
        
        // Gravity
        if(isAirborne) {
            ySpeed += GRAVITY;
        }

        // Update action status
        if(!isAirborne && isKeyPressed(actionKey)) {
            doingAction = true;
        }
        else {
            doingAction = false;
        }

        // Assume that gravity acts on the mascots
        isAirborne = true;

        location.x += xSpeed;
        location.y += ySpeed;
        
        setSprite();
    }

    protected void setSprite() {
        String spriteName = species;
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