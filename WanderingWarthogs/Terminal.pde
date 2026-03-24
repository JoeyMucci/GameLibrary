public class Terminal implements Interactable {
    private String spriteName;
    private int xBlock, yBlock;

    public Terminal(int xBlock, int yBlock) {
        this.xBlock = xBlock;
        this.yBlock = yBlock;
        spriteName = "terminal.png";
    }

    public void drawSelf() {
        image(sprites.get(spriteName).image, xBlock * BLOCK_SIZE, yBlock * BLOCK_SIZE);
    }

    public float getLeftX() {
        return xBlock * BLOCK_SIZE;
    }

    public float getRightX() {
        return (xBlock + 1) * BLOCK_SIZE;
    }

    public float getTopY() {
        return yBlock * BLOCK_SIZE;

    }

    public float getBottomY() {
        return (yBlock + 1) * BLOCK_SIZE;
    }

    public boolean underMascot() { return false;};

    // If mascots reach terminals the level is finished
    public InteractCode interact(ArrayList<Mascot> mascots) {
        for(Mascot mascot : mascots) {
            if(mascot.isGrounded() && mascot.isTouching(this)) {
                return InteractCode.TERMINAL;
            }
        }
        return InteractCode.OK;
    }
}