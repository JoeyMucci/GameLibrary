public class Human extends Mover implements Interactable {
    private final float XSPEED = 7.5;
    private final float MIN_DIST = 1.5, MAX_DIST = 12;

    public Human(int rightBlock, int bottomBlock, Direction dir) {
        super(MoverID.HUMAN, rightBlock, bottomBlock, dir);
    }

    public void moveSelf() {
        // Gravity
        if(isAirborne) {
            ySpeed += GRAVITY;
        }

        // Assume that gravity acts on the humans
        isAirborne = true;

        
        location.x += xSpeed;
        location.y += ySpeed;
    }

    // If the questing quokka is smiling, do action (run to quokka)
    public InteractCode interact(ArrayList<Mascot> mascots) {
        xSpeed = 0;
        doingAction = false;
        for(Mascot mascot : mascots) {
            if(mascot.id == MoverID.QUOKKA) {
                if(getBottomRight().y == mascot.getBottomRight().y && mascot.isGrounded()) {
                    float blockDistance = Math.abs(getMidPoint().x - mascot.getMidPoint().x) / BLOCK_SIZE;
                    if(blockDistance >= MIN_DIST && blockDistance <= MAX_DIST) {
                        doingAction = true;
                        if(mascot.doingAction) {
                            if(mascot.getMidPoint().x > getMidPoint().x) {
                                xSpeed = XSPEED;
                            }
                            else {
                                xSpeed = -XSPEED;
                            }
                        }
                    }
                }
            }
        }
        return InteractCode.OK;
    }
}