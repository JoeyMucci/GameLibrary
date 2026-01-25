public class Block implements Interactable {
    public int blockLeft, blockRight, blockTop, blockBottom;

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

    public void interact(Quokka questing, Raccoon resolute) {
        int blockLeftX = blockLeft * BLOCK_SIZE;
        int blockRightX = (blockRight + 1) * BLOCK_SIZE;
        int blockTopY = blockTop * BLOCK_SIZE;
        int blockBottomY = (blockBottom + 1) * BLOCK_SIZE;

        float leftX = questing.location.x;
        float rightX = questing.location.x + sprites.get(questing.spriteName).width;
        float topY = questing.location.y;
        float bottomY = topY + sprites.get(questing.spriteName).height;

        int xBlockMin = (int) (leftX / BLOCK_SIZE); 
        int xBlockMax = (int) (rightX / BLOCK_SIZE); 
        int yBlockMin = (int) (topY / BLOCK_SIZE);
        int yBlockMax = (int) (bottomY / BLOCK_SIZE);

        boolean xCollides = false;
        for(int block = xBlockMin; block <= xBlockMax; block++) {
            if(block >= blockLeft && block <= blockRight) {
                xCollides = true;
                break;
            }
        }

        if(xCollides) {            
            // Falling on a block
            float prevBottomY = bottomY - questing.ySpeed;
            if(prevBottomY < blockTopY && bottomY >= blockTopY) {
                questing.location.y = blockTopY - sprites.get(questing.spriteName).height - contactThreshold;
                questing.isAirborne = false;
                questing.ySpeed = 0;
            }

            // Jumping into a block
            float prevTopY = topY - questing.ySpeed;
            if(prevTopY > blockBottomY && topY <= blockBottomY) {
                questing.location.y = blockBottomY + contactThreshold;
                questing.ySpeed = 0;
            }
        }

        boolean yCollides = false;
        for(int block = yBlockMin; block <= yBlockMax; block++) {
            if(block >= blockTop && block <= blockBottom) {
                yCollides = true;
                break;
            }
        }

        if(yCollides) {
            // Left into a block
            float prevLeftX = leftX - questing.xSpeed;
            if(prevLeftX > blockRightX && leftX <= blockRightX) {
                questing.location.x = blockRightX + contactThreshold;
                questing.xSpeed = 0;
            }

            // Right into a block
            float prevRightX = rightX - questing.xSpeed;
            if(prevRightX < blockLeftX && rightX >= blockLeftX) {
                questing.location.x = blockLeftX - sprites.get(questing.spriteName).width - contactThreshold;
                questing.xSpeed = 0;
            }
        }
    }
}