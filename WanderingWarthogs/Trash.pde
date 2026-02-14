public class Trash implements Collidable, Interactable {
    private final String spriteName = "trash.png";
    private Coordinate location;
    private ItemID item;
    private boolean used;

    public Trash(ItemID item, int rightBlock, int bottomBlock) {
        float leftX = (rightBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).width;
        float topY = (bottomBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).height;
        location = new Coordinate(leftX, topY);
        this.item = item;
        used = false;
    }

    public void drawSelf() {
        // TODO: Implement unused and used sprites
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

    // The resolute raccoon can dig while atop a trash can
    public void interact(ArrayList<Mascot> mascots) {
        if(used) {
            return;
        }
        for(Mascot mascot : mascots) {
            if(mascot.id == MoverID.RACCOON && mascot.isGrounded()) {
                if(
                    mascot.getTopLeft().x < getBottomRight().x &&
                    mascot.getBottomRight().x > getTopLeft().x
                ) {
                    if(mascot.getBottomRight().y == getTopLeft().y && mascot.isDoingAction()) {
                        used = true;
                        mascot.getItem(item);
                    }
                }
            }
        }
    }
}
