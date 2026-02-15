public class Block implements Collidable {
    protected int leftBlock, rightBlock, topBlock, bottomBlock;

    public Block(int leftBlock, int rightBlock, int topBlock, int bottomBlock) {
        this.leftBlock = leftBlock;
        this.rightBlock = rightBlock;
        this.topBlock = topBlock;
        this.bottomBlock = bottomBlock;
    }

    public void drawSelf() {
        fill(GRAY);
        for(int row = topBlock; row <= bottomBlock; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = leftBlock; col <= rightBlock; col++) {
                int x = col * BLOCK_SIZE;
                rect(x, y, BLOCK_SIZE, BLOCK_SIZE);
            }
        }
    }

    public Coordinate getTopLeft() {
        return new Coordinate(leftBlock * BLOCK_SIZE, topBlock * BLOCK_SIZE);
    }

    public Coordinate getBottomRight() {
        return new Coordinate((rightBlock + 1) * BLOCK_SIZE, (bottomBlock + 1) * BLOCK_SIZE);
    }
    
}