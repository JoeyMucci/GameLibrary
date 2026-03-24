public class Door implements Collidable, Interactable {
    private String spriteName;
    private Coordinate location;
    private boolean isRed;

    public Door(int rightBlock, int bottomBlock, boolean isRed) {
        spriteName = "door" + "-" + (isRed ? "red" : "blue") + ".png";
        float leftX = (rightBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).width;
        float topY = (bottomBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).height;
        location = new Coordinate(leftX, topY);
        this.isRed = isRed;
    }

    public void drawSelf() {
        fill(DARK_ABG);
        image(sprites.get(spriteName).image, location.x, location.y);
    }

    public Coordinate getTopLeft() {
        return location;
    }

    public Coordinate getBottomRight() {
        float rightX = location.x + sprites.get(spriteName).width;
        float bottomY = location.y + sprites.get(spriteName).height;
        return new Coordinate(rightX, bottomY);
    }

    public ItemID getKey() {
        return isRed ? ItemID.REDKEY : ItemID.BLUEKEY;
    }

    public boolean hasRightKey(Mascot mascot) {
        return mascot.hasItem(getKey());
    }

    public boolean underMascot() { return true;};

    // The resolute raccoon can open doors if it has the matching key
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(mascot.id == MoverID.RACCOON && hasRightKey(mascot) && mascot.isGrounded()) {
                if(
                    (leftInto(mascot, this) || rightInto(mascot, this)) &&
                    mascot.getBottomRight().y == getBottomRight().y
                ) {
                    location = OFFSCREEN;
                    mascot.removeItem(getKey());
                }
            }
        }
        return InteractCode.OK;
    }
}