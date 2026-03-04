public class Mascot extends Mover {
    private final float XSPEED = 5, JUMPSPEED = 9, DISMOUNT_SPEED = 1;
    private MovementKeys keys;
    private boolean canJump, isMagnetized;
    private ArrayList<ItemID> items;

    public Mascot(MoverID id, int rightBlock, int bottomBlock, Direction dir) {
        super(id, rightBlock, bottomBlock, dir);
        this.items = new ArrayList<ItemID>();
        keys = mascotKeys.get(id);
        canJump = true;
    }

    public void drawSelf() {
        super.drawSelf();

        // Draw items
        for(ItemID itemId : items) {
            String itemName = itemNames.get(itemId);
            String dir = isFacingRight() ? "right" : "left";
            String spriteName = itemName + "-" + dir + ".png"; 
            image(sprites.get(spriteName).image, location.x, location.y);
        }
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
            dir = Direction.LEFT;
        }
        // Going right
        else if(isKeyPressed(keys.right) && !isKeyPressed(keys.left)) {
            xSpeed = XSPEED;
            dir = Direction.RIGHT;
        }
        else {
            xSpeed = 0;
            // Update action status only if not moving
            if(!isAirborne && isKeyPressed(keys.action)) {
                if(isMagnetized) {
                    ySpeed = DISMOUNT_SPEED;
                    isMagnetized = false;
                }
                else {
                    if(!hasItem(ItemID.REDKEY) && !hasItem(ItemID.BLUEKEY)) {
                        doingAction = true;
                    }
                }
            }
        }

        // Assume that gravity acts on the mascots
        isAirborne = true;

        location.x += xSpeed;
        location.y += ySpeed;
    }

    public void getItem(ItemID item) {
        items.add(item);
    }

    public void removeItem(ItemID item) {
        items.remove(item);
    }

    public boolean hasItem(ItemID item) {
        return items.contains(item);
    }

    public void magnetize() {
        ground();
        isMagnetized = true;
    }

    public boolean isTouching(Chip chip) {
        return (
            getTopLeft().x < chip.getRightX() &&
            getTopLeft().y < chip.getBottomY() &&
            getBottomRight().x > chip.getLeftX() &&
            getBottomRight().y > chip.getTopY()
        );
    }

    public boolean isTouching(Terminal terminal) {
        return (
            getTopLeft().x < terminal.getRightX() &&
            getTopLeft().y < terminal.getBottomY() &&
            getBottomRight().x > terminal.getLeftX() &&
            getBottomRight().y > terminal.getTopY()
        );
    }
}