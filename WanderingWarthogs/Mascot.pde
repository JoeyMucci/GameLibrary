public class Mascot extends Mover {
    private final float XSPEED = 5, JUMPSPEED = 9, GRAVITY = 1.0 / 3.0;
    private MovementKeys keys;
    private boolean canJump;

    public Mascot(MoverID id, int rightBlock, int bottomBlock, boolean facingRight) {
        super(id, rightBlock, bottomBlock, facingRight);
        keys = mascotKeys.get(id);
        canJump = true;
    }

    public void moveSelf() {
        // Initiate jump
        if(canJump && !isAirborne && isKeyPressed(keys.jump)) {
            ySpeed -= JUMPSPEED;
            canJump = false;
        }

        // Have to release jump while on the ground to be able to jump again
        if(!isAirborne && !isKeyPressed(keys.jump)) {
            canJump = true;
        }
        
        // Gravity
        if(isAirborne) {
            ySpeed += GRAVITY;
        }

        doingAction = false;
        // Going left
        if(isKeyPressed(keys.left) && !isKeyPressed(keys.right)) {
            xSpeed = -XSPEED;   
            facingRight = false;
        }
        // Going right
        else if(isKeyPressed(keys.right) && !isKeyPressed(keys.left)) {
            xSpeed = XSPEED;
            facingRight = true;
        }
        else {
            xSpeed = 0;
            // Update action status only if not moving
            if(!isAirborne && isKeyPressed(keys.action)) {
                doingAction = true;
            }
        }

        // Assume that gravity acts on the mascots
        isAirborne = true;

        location.x += xSpeed;
        location.y += ySpeed;
    }
}