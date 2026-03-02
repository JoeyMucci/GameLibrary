public class Chip implements Interactable {
    private final float CONTACT_BUFFER = 10;
    private ChipID id;
    private Coordinate location;
    private String spriteName;

    // It is useful to have chips at half heights
    public Chip(float rightBlock, float bottomBlock, ChipID id) {
        if(id == ChipID.QUESTING) {
            spriteName = "questing-chip.png";
        }
        else if(id == ChipID.RESOLUTE) {
            spriteName = "resolute-chip.png";
        }
        else {
            spriteName = "canonical-chip.png";
        }
        float leftX = (rightBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).width;
        float topY = (bottomBlock + 1) * BLOCK_SIZE - sprites.get(spriteName).height;
        location = new Coordinate(leftX, topY);
        this.id = id;
    }

    public void drawSelf() {
        image(sprites.get(spriteName).image, location.x, location.y);
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

    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(
                id == ChipID.CANONICAL ||  
                id == ChipID.QUESTING && mascot.id == MoverID.QUOKKA ||
                id == ChipID.RESOLUTE && mascot.id == MoverID.RACCOON 
            ) {
                if(mascot.isTouching(this)) {
                    return InteractCode.HIT;
                }
            }
        }
        return InteractCode.OK;
    }
}