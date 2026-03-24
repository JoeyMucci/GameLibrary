public class BoundaryBlock extends Block {
    public BoundaryBlock(int leftBlock, int rightBlock, int topBlock, int bottomBlock) {
        super(leftBlock, rightBlock, topBlock, bottomBlock);
        spriteName = "spikeblock.png";
    }

    public void drawSelf() {
        fill(DARK_ABG);
        stroke(DARK_ABG);
        strokeWeight(DEFAULT_STROKE);
        for(int row = topBlock; row <= bottomBlock; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = leftBlock; col <= rightBlock; col++) {
                int x = col * BLOCK_SIZE;
                rect(x, y, BLOCK_SIZE, BLOCK_SIZE);
            }
        }
    }
}