public abstract class Mascot {
    private final float XSPEED = 5, JUMPSPEED = 10, GRAVITY = 1.0 / 3.0;
    public float ySpeed = 0;

    public Coordinate location;
    public boolean facingRight, doingAction, isAirborne;

    protected int leftKey, rightKey, jumpKey, actionKey;
    protected String species;
    protected PImage sprite;

    protected Mascot(float x, float y, boolean facingRight) {
        this.location = new Coordinate(x, y);
        this.facingRight = facingRight;
        doingAction = false;
        isAirborne = false;
    }

    public void drawSelf() {
        image(sprite, location.x, location.y);
    }

    public void moveSelf() {
        // Going left
        if(isKeyPressed(leftKey) && !isKeyPressed(rightKey)) {
            location.x -= XSPEED;   
            facingRight = false;
        }
        // Going right
        else if(isKeyPressed(rightKey) && !isKeyPressed(leftKey)) {
            location.x += XSPEED;
            facingRight = true;
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

        location.y += ySpeed;

        // Update action status
        if(!isAirborne && isKeyPressed(actionKey)) {
            doingAction = true;
        }
        else {
            doingAction = false;
        }

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
        sprite =  sprites.get(spriteName).image;
    }

}