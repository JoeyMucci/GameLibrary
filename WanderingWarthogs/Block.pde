public class Block implements Collidable {
    protected int blockLeft, blockRight, blockTop, blockBottom;

    public Block(int blockLeft, int blockRight, int blockTop, int blockBottom) {
        this.blockLeft = blockLeft;
        this.blockRight = blockRight;
        this.blockTop = blockTop;
        this.blockBottom = blockBottom;
    }

    public void drawSelf() {
        fill(GRAY);
        for(int row = blockTop; row <= blockBottom; row++) {
            int y = row * BLOCK_SIZE;
            for(int col = blockLeft; col <= blockRight; col++) {
                int x = col * BLOCK_SIZE;
                rect(x, y, BLOCK_SIZE, BLOCK_SIZE);
            }
        }
    }

    public Coordinate getTopLeft() {
        return new Coordinate(blockLeft * BLOCK_SIZE, blockTop * BLOCK_SIZE);
    }

    public Coordinate getBottomRight() {
        return new Coordinate((blockRight + 1) * BLOCK_SIZE, (blockBottom + 1) * BLOCK_SIZE);
    }
    
}