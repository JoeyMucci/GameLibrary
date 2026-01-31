public class Block implements Interactable {
    private int blockLeft, blockRight, blockTop, blockBottom;

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

    public void interact(Mover[] movers) {
        Coordinate blockTopLeft = new Coordinate(blockLeft * BLOCK_SIZE, blockTop * BLOCK_SIZE);
        Coordinate blockBottomRight = new Coordinate((blockRight + 1) * BLOCK_SIZE, (blockBottom + 1) * BLOCK_SIZE);

        for(Mover mover : movers) {
            Coordinate topLeft = mover.getTopLeft();
            Coordinate bottomRight = mover.getBottomRight();
            Coordinate prevTopLeft = mover.getPrevTopLeft();
            Coordinate prevBottomRight = mover.getPrevBottomRight();

            int xBlockMin = (int) ((topLeft.x + CONTACT_THRESHOLD) / BLOCK_SIZE); 
            int xBlockMax = (int) ((bottomRight.x - CONTACT_THRESHOLD) / BLOCK_SIZE); 
            int yBlockMin = (int) ((topLeft.y + CONTACT_THRESHOLD) / BLOCK_SIZE);
            int yBlockMax = (int) ((bottomRight.y - CONTACT_THRESHOLD) / BLOCK_SIZE);

            boolean yCollides = false;
            for(int block = yBlockMin; block <= yBlockMax; block++) {
                if(block >= blockTop && block <= blockBottom) {
                    yCollides = true;
                    break;
                }
            }

            if(yCollides) {
                // Left into a block
                if(prevTopLeft.x >= blockBottomRight.x && topLeft.x <= blockBottomRight.x) {
                    mover.setLeftX(blockBottomRight.x);
                }

                // Right into a block
                if(prevBottomRight.x <= blockTopLeft.x && bottomRight.x >= blockTopLeft.x) {
                    mover.setRightX(blockTopLeft.x);
                }
            }

            boolean xCollides = false;
            for(int block = xBlockMin; block <= xBlockMax; block++) {
                if(block >= blockLeft && block <= blockRight) {
                    xCollides = true;
                    break;
                }
            }

            if(xCollides) {        
                // Falling on a block
                if(prevBottomRight.y <= blockTopLeft.y && bottomRight.y >= blockTopLeft.y) {
                    mover.setBottomY(blockTopLeft.y);
                    mover.ground();
                }

                // Jumping into a block
                if(prevTopLeft.y >= blockBottomRight.y && topLeft.y <= blockBottomRight.y) {
                    mover.setTopY(blockBottomRight.y);
                }
            }
        }
    }
}